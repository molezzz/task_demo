#
# 用于处理Event模板
#
# @author [molezz]
#
module MonitorEventHelper
  extend ActiveSupport::Concern

  def compile(event)
    result = { title: '', content: ''}
    target_class = Object.const_get event.target
    return result if !target_class
    config = target_class.event_config(event.kind)
    return result if !config

    #读取原始数据
    data = event.data || {}

    hooks = {
      'datetime' => ->(obj, event){

      }
    }

    #处理title模板
    unless config.title_tpl.nil?
      #从模板中提取'{{name|action}}'这种格式的变量
      result[:title] = config[:title_tpl].gsub(/{{([\s\S]+?)}}/) do |match|
        name, hook = ($1).split('|').collect {|s| s.strip }
        #处理 foo.bar 的形式
        members = name.split('.')
        key = members.shift
        key = 'target_snap' if key == 'self'
        #检查数据中是否有相应的key
        if data.key?(key)
          obj = data[key]
          #如果是成员操作，取出成员
          if !members.blank?
            members.each {|member| obj = obj[member]  }
          end

          #检查是否有filter，有则执行
          if hook && hooks.key?(hook)

          end

          obj

        end

      end
    end


  end

end