class Project < ActiveRecord::Base
  include AutoKeygen

  belongs_to :team
  has_many  :todos
  has_many :users , through: :accesses

  validates :title, presence: true

end
