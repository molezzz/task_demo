class Comment < ActiveRecord::Base
  include AutoKeygen

  belongs_to :user
  belongs_to :todo

  validates :content, presence: true

end
