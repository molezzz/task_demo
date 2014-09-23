#
# 提供DSL风格的Event监控设置
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
    #
    # @return [Boolean]
    def check_filters(*args)

      self[:filters].each do |filter|
        return false if !filter.call(*args)
      end if self[:filters]

      return true
    end

  end

  module ClassMethods
    def with_event
      self.send :extend, ::MonitorWithEvent::BuilderMethods
      yield if block_given?
    end
  end

  module BuilderMethods

    def self.extended(base)
      Rails.logger.debug "extending by #{base}"

      config = {}

      #添加一个虚拟属性，以便设置事件来源
      base.send :attr_accessor,:event_source

      base.singleton_class.instance_eval do

        define_method(:events_config) do
          config.dup
        end

        define_method(:on) do |op, &block|

          builder = EventBuilder.new

          if [:create,:destroy].include? op
            block.call(builder)
            kind = [base.name, op, builder[:name]].compact.join('_')
            config[kind] ||= []
            config[kind] = builder

            base.send "after_#{op}" do
              #如果设置了filter，调用filter并检查是否符合规则
              next if !builder.check_filters(self)
              Event.new({
                kind: kind,
                #todo Fix this
                source_id: self.event_source.try(:id),
                target: base.name,
                target_id: self.id
              }).save!
            end

          end

          #如果参数是hash，则监控属性的改变
          if op.is_a? Hash
            #如果未声明监控的属性或者属性不存在，则跳过
            next if op[:attr].blank? || base.column_names.include?(op[:attr])
            block.call(builder)

            #处理 from,to 条件
            builder.filter do |record|
              #调用 xxx_changed? 方法检查是不是发生了期待的改变
              record.send "#{op[:attr]}_changed?", op.select { |key, value| [:from, :to].include? key }
            end if op.key?(:from) || op.key?(:to)

            kind = [base.name, 'attr', op[:attr], 'changed', builder[:name]].compact.join('_')
            config[kind] ||= []
            config[kind] = builder

            base.after_save do
              #检查是否是已有对象，并且设定的属性是否发生了变化，不是已有对象或属性未变化则直接跳过
              p [!self.id_changed?,self.send("#{op[:attr]}_changed?")]
              next if self.id_changed? || !self.send("#{op[:attr]}_changed?")
              #如果设置了filter，调用filter并检查是否符合规则
              next if !builder.check_filters(self)
              Event.new({
                kind: kind,
                #todo Fix this
                source_id: self.event_source.try(:id),
                target: base.name,
                target_id: self.id
              }).save!
            end

          end

        end

      end

    end

  end
end

ActiveRecord::Base.send :include, MonitorWithEvent