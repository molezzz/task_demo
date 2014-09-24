#
# 提供DSL风格的Event监控设置
# @todo 讨论是否要在设置非法时抛出异常
#
# @author [molezz]
#
module MonitorWithEvent
  extend ActiveSupport::Concern

  class EventBuilder < Hash

    #
    # 指定event的标题模板
    # @todo 可以加上更复杂的模板处理
    # @param tpl [string] 标题模板字符串
    #
    # @return [EventBuilder]
    def title_tpl(tpl)
      self[:title_tpl] = tpl
    end

    #
    # 指定event内容的模板
    # @todo 可以加上更复杂的模板处理
    # @param tpl [String] [description]
    #
    # @return [EventBuilder]
    def content_tpl(tpl)
      self[:content_tpl] = tpl
    end


    #
    # 指定event的名称
    # @param name [String]
    #
    # @return [EventBuilder]
    def name(name)
      self[:name] = name
    end


    #
    # 设置一个filter，当filter返回值为真时规则生效
    # @param &block [Block]
    #
    # @return [EventBuilder]
    def filter(&block)
      self[:filters] ||= []
      self[:filters].unshift block
    end


    #
    # 依次检测filter列表并返回结果
    # filter可以接受三个参数
    #   record [ActiveRecord] 更新的对象
    #   to [Object] 新值
    #   from [Object] 旧值
    #
    #
    # @return [Boolean]
    def check_filters(*args)

      self[:filters].each do |filter|
        return false if !filter.call(*args)
      end if self[:filters]

      return true
    end

    #
    # 用于生成并保存Event
    # @param target [ActiveRecord]
    # @param kind [String]
    # @param data=nil [Hash] 要一并保存的其他数据
    #
    # @return [Boolean]
    def event_create(target, kind, data=nil)
      Event.new({
        kind: kind,
        source_id: target.event_source.try(:id),
        target: target.class.name,
        target_id: target.id
      }).save!
    end

  end

  module ClassMethods

    def as_event_target
      self.send :extend, BuilderClassMethod
      yield if block_given?
    end

    module BuilderClassMethod

      def self.extended(base)
        Rails.logger.debug "extending by #{base}"

        config = {}

        #添加一个虚拟属性，以便设置事件来源
        base.send :attr_accessor,:event_source

        # 生成关联
        # @todo 自定义关联
        base.send :has_many, :events, -> { where(target: base.name)},
                             foreign_key: 'target_id', class_name: 'Event'

        base.singleton_class.instance_eval do

          define_method(:events_config) do
            config.dup
          end

          define_method(:on) do |op, &block|

            if [:create,:destroy].include? op
              add_create_del_handler(base, op, config, block)
            end

            # 如果参数是hash，则监控属性或关联关系的改变
            if op.is_a? Hash
              add_attr_change_handler(base, op, config, block) if !op[:attr].blank?
              add_asso_handler(base, op, config, block) if !op[:asso].blank?
            end

          end #define_method :on

        end # base.singleton_class.instance_eval


      end #self.extended


      private
      # @todo 讨论是否要在设置非法时抛出异常
      def add_create_del_handler(base, op, config, block)
        builder = EventBuilder.new
        block.call(builder)
        kind = [base.name, op, builder[:name]].compact.join('_').downcase
        config[kind] ||= []
        config[kind] = builder

        base.send "after_#{op}" do
          #NOTE 这里的self是被创建或修改的对象
          #如果设置了filter，调用filter并检查是否符合规则
          next if !builder.check_filters(self, nil, nil)
          builder.event_create(self, kind)
        end
      end

      # @todo 讨论是否要在设置非法时抛出异常
      def add_attr_change_handler(base, op, config, block)
        # 如果未声明监控的属性或者属性不存在，则跳过
        return if !base.column_names.include?(op[:attr].to_s)
        builder = EventBuilder.new
        block.call(builder)

        #处理 from,to 条件
        builder.filter do |record|
          #调用 xxx_changed? 方法检查是不是发生了期待的改变
          record.send "#{op[:attr]}_changed?", op.select { |key, value| [:from, :to].include? key }
        end if op.key?(:from) || op.key?(:to)

        kind = [base.name, 'attr', op[:attr], 'changed', builder[:name]].compact.join('_').downcase
        config[kind] ||= []
        config[kind] = builder

        base.after_save do
          #NOTE 这里的self是被修改的对象
          #检查是否是已有对象，并且设定的属性是否发生了变化，不是已有对象或属性未变化则直接跳过
          next if self.id_changed? || !self.send("#{op[:attr]}_changed?")
          #如果设置了filter，调用filter并检查是否符合规则
          from, to = self.send("#{op[:attr]}_change")
          next if !builder.check_filters(self, to, from)
          builder.event_create(self, kind)
        end
      end

      # @todo 讨论是否要在设置非法时抛出异常
      def add_asso_handler(base, op, config, block)
        #不指定 :to 时，默认为 :add
        op[:to] ||= :add
        #检查是否存在关联关系
        return if !base.reflections.key?(op[:asso]) || ![:add,:remove].include?(op[:to])

        builder = EventBuilder.new
        block.call(builder)
        kind = [base.name, 'asso', op[:asso], op[:to]].compact.join('_').downcase
        config[kind] ||= []
        config[kind] = builder

        method = :"after_#{op[:to]}"
        asso = base.reflect_on_association(op[:asso])
        #保留用户自定义的响应回调
        callback = [asso.options[method]].flatten.compact
        callback << Proc.new do |target, record|
          #NOTE record是被新建或删除的另一端对象
          #如果设置了filter，调用filter并检查是否符合规则
          next if !builder.check_filters(target, nil, nil)
          builder.event_create(target, kind, {"#{record.class.name.downcase}" => record})
        end
        base.send(asso.macro, op[:asso], asso.options.merge(method => callback))
      end

    end


  end #ClassMethods

end

ActiveRecord::Base.send :include, MonitorWithEvent