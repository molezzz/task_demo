class Todo < ActiveRecord::Base
  include AutoKeygen
  include Rails.application.routes.url_helpers

  belongs_to :project
  has_many :comments, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :content, presence: true


  as_event_target do

    #创建任务
    on :create do |cfg|

      cfg.title_tpl 'create a new todo'
      cfg.default_source_id do |todo|
        todo.creator_id
      end

    end

    #修改任务
    on(attr: :content) do |cfg|

      cfg.title_tpl 'change the todo content to {{to}}'

    end

    #完成任务
    on(attr: :complate_at, from: nil) do |cfg|

      cfg.name 'finished'
      cfg.title_tpl 'complate todo at {{to}}'

    end

    #修改完成时间
    on(attr: :complate_at) do |cfg|

      cfg.name 'fix_complate'
      cfg.title_tpl 'change todo fininsed time from: {{from}} to: {{to}} '
      #使用filter区分任务完成
      cfg.filter do |record, to, from|
        !to.nil? && !from.nil?
      end

    end

    #重新打开任务
    on(attr: :complate_at, to: nil) do |cfg|

      cfg.name 'reopen'
      cfg.title_tpl 'reopen todo at {{to}}'

    end

    #修改任务结束时间
    on(attr: :end_at) do |cfg|
      cfg.name 'change_end'
      cfg.title_tpl 'change deadline from:{{from}} to: {{to}}'

    end

    #派发任务
    on(attr: :owner_id, from: nil) do |cfg|

      cfg.name 'dispatch'
      cfg.title_tpl 'dispatch to {{to}}'

    end

    #重新派发任务
    on(attr: :owner_id) do |cfg|

      cfg.name 'redispatch'
      cfg.title_tpl 'redispatch from {{from}} to {{to}}'
      #在这里添加filter区分派发任务
      cfg.filter do |record, to, from|
        # 只有owner_id在两个用户之间发生变化时才收集
        !to.nil? && !from.nil?
      end

    end

    #取消派发任务
    on(attr: :owner_id, to: nil) do |cfg|

      cfg.name 'revoke'
      cfg.title_tpl 'todo revoked'

    end

    #开始执行一个任务
    on(attr: :begin_at, from: nil) do |cfg|

      cfg.name 'go'
      cfg.title_tpl 'start {{self.name}}'

    end

    #任务被销毁，实际上这个应该用不到
    on :destroy do |cfg|

      cfg.title_tpl 'destroy the todo'

    end

    #添加任务评论
    on(asso: :comments, to: :add) do |cfg|

      cfg.title_tpl 'add comment to this todo'
      cfg.content_tpl '{{comment.content}}'

    end


  end #as_event_target

  #
  # 完成任务
  # @param time = nil [Datetime] 可选的完成时间
  #
  # @return [Boolean]
  def complate(time = nil)
    update_attribute(:complate_at, time || Time.now)
  end

  #
  # 给某人派发或重新派发任务
  # @param user [User] 要派发的人
  # @param redispatch = false [Boolean] 是否重新派发
  #
  # @return [Boolean]
  def dispatch_to(user, redispatch = false)
    return false if !user.is_a?(User) || (!owner_id.nil? && !redispatch)
    update_attribute(:owner_id, user.id)
  end


  #
  # 开始执行一个任务
  # @todo 讨论是否要限制只有任务的被派发者才能开始任务
  #
  # @return [Boolean]
  def go
    update_attribute(:begin_at, Time.now)
  end

  #
  # 重新打开任务
  #
  # @return [Boolean]
  def reopen
    update_attribute(:complate_at, nil)
  end

  #
  # 取消任务派发
  #
  # @return [Boolean]
  def revoke
    update_attribute(:owner_id, nil)
  end

end
