#
# Eventable
#
# @author [molezz]
#
module Eventable
  extend ActiveSupport::Concern

  included do
    #由于https://github.com/rails/rails/issues/2822
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
            key = [self.class.name, kind, attr, cfg[:name]].compact.join('.').downcase
            create_event(key, cfg, configs[:default_source], to, from)
          end
        end
      else
        config = configs[kind]        
        config_prepare(config).each do |cfg|                   
          key = [self.class.name, kind, cfg[:name]].compact.join('.').downcase
          create_event(key, cfg, configs[:default_source])
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

    def create_event(key, config, default_source, to = nil, from = nil)
      #调用filter进行过滤
      return false if config[:filter].respond_to?(:call) && !self.instance_exec(to, from, &config[:filter])
      #处理source
      #source的优先级 self.event_source > 配置文件中的source > default_source
      source = self.event_source || config[:source] || default_source


      Event.create!(
        kind: key,
        source: !source.respond_to?(:call) ? nil : self.instance_exec(&source), 
        eventable: self
      )

    end

end