class User < ActiveRecord::Base
  include AutoKeygen

  belongs_to :team

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
end
