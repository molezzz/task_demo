class User < ActiveRecord::Base
  include AutoKeygen

  belongs_to :team
  has_many :projects, through: :accesses
  has_many :todos, foreign_key: 'owner_id'
  has_many :created_todos, class_name: 'Todo', foreign_key: 'creator_id'
  
  has_many :comments

  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                      message: I18n.t('errors.messages.email'),
                      allow_blank: true
                    },
                    on: :create

  validates :avatar, allow_blank: true,
                     format: {
                       with: %r{\.(gif|jpg|png|jpeg)\Z}i,
                       message: I18n.t('errors.messages.avatar'),
                       allow_blank: true
                     }

  as_event_source

end
