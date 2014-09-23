class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo

  validates :content, presence: true

end
