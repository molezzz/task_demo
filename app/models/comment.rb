class Comment < ActiveRecord::Base
  include AutoKeygen
  include Eventable

  belongs_to :user
  belongs_to :todo

  validates :content, presence: true

  class << self
    # 设置需要监控事件，以及模板
    #
    # @return [Hash]
    def monitor_configs
      {
        default_source: ->{ self.user },
        created: {
          name: :to_todo,
          filter: ->(to, from){
            #这里的self指代被创建的 comment
            !self.todo_id.nil?
          },
          source: ->{
            self.todo.event_source || self.user
          }
        }
      }
    end
  end

end
