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
    # 添加一个hook供编译模板时调用
    # @param name [Symbol] hook的名字
    # @param proc [Proc]
    #
    # @return [EventBuilder]
    def hook(name, proc)
      self[:hooks] ||= {}
      self[:hooks][name.to_s] = proc
    end


    #
    # 可以指定一个块来设置默认的source_id
    # 当:event_source未被设置时，调用这个块获取source对象
    # 一般用于对象被创建时
    # block 接受一个参数 target 对象
    # @todo 这个是否应该放在全局
    #
    # @return [type] [description]
    def default_source_id(&block)
      self[:default_source_id] = block
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
    # @param data={} [Hash] 要一并保存的其他数据
    #
    # @return [Boolean]
    def event_create(target, kind, data={})
      source_id = target.event_source.try(:id)
      source_id = self[:default_source_id].call(target) if source_id.nil? && self[:default_source_id].respond_to?(:call)

      Event.new({
        kind: kind,
        source_id: source_id,
        target: target.class.name,
        target_id: target.id,
        data: data.update(self.compile(data))
      }).save!
    end

    def compile(data)
      result = { title: '', content: ''}
      config = self

      hooks = {
        'datetime' => ->(time){
          if time.respond_to? :strftime
            time.strftime('%Y-%m-%d %H:%M:%S')
          else
            time
          end
        }
      }

      hooks.merge!(self[:hooks]) if self[:hooks]

      #处理模板

      [:title, :content].each do |attr|
        #从模板中提取'{{name|action}}'这种格式的变量
        result[attr] = self[:"#{attr}_tpl"].gsub(/{{([\s\S]+?)}}/) do |match|
          name, hook = ($1).split('|').collect {|s| s.strip }
          #处理 foo.bar 的形式
          members = name.split('.')
          key = members.shift
          key = 'target_snap' if key == 'self'
          key = key.to_sym
          #检查数据中是否有相应的key
          if data.key?(key)
            obj = data[key]
            #如果是成员操作，取出成员
            if !members.blank?
              members.each {|member| obj = obj.send(member) if obj.respond_to?(member) }
            end

            #检查是否有filter，有则执行
            if hook && hooks.key?(hook)
              obj = hooks[hook].call(obj)
            end

            obj

          end

        end unless self[:"#{attr}_tpl"].nil?
      end

      data.each do |k,v|
        result[k] = v.respond_to?(:attributes) ? v.send(:attributes) : v
      end

      result

    end #compile

  end

  module ClassMethods


    def as_event_target
      if self.table_exists? #确保migrate能正常执行
        self.send :extend, TargetClassMethod
        yield if block_given?
      end
    end

    def as_event_source
      self.send :include, SourceInstanceMethod
    end

    module SourceInstanceMethod

      def self.included(base)

        # 定义关联
        # @note 这里只是个简单的实现，实际上可以添加source字段配合source_id实现任何类作为event的发起者
        base.send(:has_many, :events, foreign_key: 'source_id')

      end

      #
      # 调用该方法并在块内操作，以保证event可以被正确记录
      # @param target_object [ActiveRecord] 目标对象
      # @param &block [Block]
      #
      # @return [Object]
      def will_change(target_object, &block)
        target_object.event_source = self
        block.call(target_object)
      end

    end


    module TargetClassMethod

      def self.extended(base)
        Rails.logger.debug "extending by #{base}"

        config = {}

        #添加一个虚拟属性，以便设置事件来源
        base.send :attr_accessor,:event_source

        # 生成关联
        # @todo 自定义关联
        base.send :has_many, :events, -> { where(target: base.name)},
                             foreign_key: 'target_id', class_name: 'Event'

        Event.send :belongs_to, :"#{base.name.downcase}", -> { where('events.target' => base.name)},
                                foreign_key: 'target_id'

        base.singleton_class.instance_eval do

          define_method(:event_configs) do
            @_config ||= config.dup
          end

          define_method(:event_config) do |key|
            event_configs[key]
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
          builder.event_create(self, kind, {target_snap: self})
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
          builder.event_create(self, kind, {target_snap: self, attr: op[:attr], from: from, to: to})
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
          builder.event_create(target, kind, {target_snap: target, :"#{record.class.name.downcase}" => record})
        end
        base.send(asso.macro, op[:asso], asso.options.merge(method => callback))
      end

    end


  end #ClassMethods

end

ActiveRecord::Base.send :include, MonitorWithEvent