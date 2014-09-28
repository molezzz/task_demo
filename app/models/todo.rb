class Todo < ActiveRecord::Base
  include AutoKeygen
  include Eventable

  belongs_to :project
  has_many :comments, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :content, presence: true

  class << self
    # 设置需要监控事件，以及模板
    #
    # @return [Hash]
    def monitor_configs
      {
        default_source: ->(){ self.creator }, #在未指定 event_source 或块内 source 的时候，默认的事件对象
        created: true, #创建任务
        destroyed: true, #销毁任务
        changed: {
          content: { name: :modify }, #修改任务内容
          complate_at: [
            { name: :finished, filter: ->(to, from){ from == nil } }, #完成任务
            { name: :fix_complate, filter: ->(to, from){ from != nil && to != nil } }, #修改完成时间
            { name: :reopen, filter: ->(to){ to == nil }} #重新打开任务
          ]
          end_at: { name: :change_end }, #修改任务结束时间
          owner_id: { name: :dispatch, filter: ->(to, from){ from == nil} }, #派发任务
          owner_id: { name: :redispatch, filter: ->(to, from){ from != nil && to != nil } }, #重新派发任务
          owner_id: { name: :revoke, filter: ->(to){ to == nil} }, #取消任务派发
          begin_at: { name: :go, filter: ->(to, from){ from == nil } }, #开始执行任务
          delete_at: { name: :delete, filter: ->(to, from){ from == nil} } #删除任务
          #由于这种写法不好监测关联，所以对评论的记录被移到Comment模型
        }
      }
    end

  end


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

  #
  # 标记删除
  #
  # @return [type] [description]
  def del
    update_attribute(:delete_at, Time.zone.now)
  end

end
