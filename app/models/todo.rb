class Todo < ActiveRecord::Base
  include AutoKeygen

  belongs_to :project
  has_many :comments
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :content, presence: true

  with_event do

    #创建任务
    on :create do |cfg|

      cfg.title_tpl 'create a new todo'

    end

    #修改任务
    on({attr: :content}) do |cfg|

      cfg.title_tpl 'change the todo content to {{to}}'

    end

    #派发任务
    on({attr: :owner_id, from: nil}) do |cfg|

      cfg.name 'dispatch'
      cfg.title_tpl 'dispatch to {{to}}'

    end

    #重新派发任务
    on({attr: :owner_id}) do |cfg|

      cfg.name 'redispatch'
      cfg.title_tpl 'redispatch from {{from}} to {{to}}'

    end

    #任务被销毁，实际上这个应该用不到
    on :destroy do |cfg|

      cfg.title_tpl 'destroy the todo'

    end

  end

end
