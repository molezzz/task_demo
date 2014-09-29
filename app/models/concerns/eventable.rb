#
# Eventable
#
# @author [molezz]
#
module Eventable
  extend ActiveSupport::Concern

  included do
    #由于has_many端不能正确处理foreign_type，see: https://github.com/rails/rails/issues/2822
    #所以这里没有使用 as
    #has_many :events, as: :eventable
    has_many :events, ->(t){ where(target: t.class.name)}, foreign_key: 'target_id'
    after_save :monitor_action
    after_destroy :monitor_action
    attr_accessor :event_source

  end

  module ClassMethods
    #
    # 设置需要监控事件，以及模板
    #
    # @return [Hash]
    def monitor_configs
      # override this to set configs
      {}
    end
  end

  #
  # 将对象转换成快照格式
  # @param except = [] [Array] 可以指定那些属性不被转化
  #
  # @return [Hash]
  def to_snap(except = [:created_at])
    except = Hash[except.map {|name| [name.to_s, 1]}]
    self.attributes.select {|k, v| !except.key?(k) }
  end

  protected
    def monitor_action
      configs = self.class.monitor_configs
      attribute = nil
      kind = if self.destroyed?
               :destroyed
             elsif self.changed? && !self.id_changed?
               :changed
             else
               #不是上述情况，且触发了after_save，那只有create
               :created
             end

      #如果要监控的事件未设置，直接退出
      return if !configs[kind]

      if kind == :changed
        #有时候同时会有一些属性同时发生变化
        self.changes.each do |attr, change|
          from, to = change
          attribute = attr.to_sym
          config = configs[:changed][attribute]
          next if !config
          config_prepare(config).each do |cfg|
            create_event(self.class.name, kind, attr, cfg, configs[:default_source], to, from)
          end
        end
      else
        config = configs[kind]
        config_prepare(config).each do |cfg|
          create_event(self.class.name, kind, nil, cfg, configs[:default_source])
        end
      end

    end

    #
    # 整理config，处理成 [{规则1}, {规则2}]
    # @param config [Boolean|Hash|Array]
    #
    # @return [Array]
    def config_prepare(config)
      #处理是 true 的情况
      config = {} if config == true
      #处理是 hash 的情况
      config = [config] if config.is_a? Hash
      config
    end

    def create_event(prefix, kind, attr, config, default_source, to = nil, from = nil)
      #调用filter进行过滤
      return false if config[:filter].respond_to?(:call) && !self.instance_exec(to, from, &config[:filter])
      target = self
      #如果是关联关系，指定目标为关联对象
      target = self.instance_eval(&config[:belongs_to]) if config[:belongs_to]
      #处理source
      #source的优先级 target.event_source > 配置文件中的source > default_source
      source = target.event_source.nil? ? nil : -> { target.event_source }
      source = source || config[:source] || default_source

      key = [self.class.name, kind, attr, config[:name] || 'default'].compact.join('.').downcase
      data = {}
      if attr
        data[:attr] = attr
        data[:from] = from
        data[:to] = to
      end
      #截取关联关系快照
      if config[:belongs_to]
        data[:asso] = self.class.name.downcase
        data[:to] = self.to_snap if kind == :created
        data[:from] = self.to_snap if kind == :destroyed
        #@todo 是否要加入 updated 的处理
      end

      data[:target_snap] = target.to_snap if kind == :destroyed && !config[:belongs_to]

      Event.create!(
        kind: key,
        source: !source.respond_to?(:call) ? nil : self.instance_exec(&source),
        eventable: target,
        data: data
      )

    end

end