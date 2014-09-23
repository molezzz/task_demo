class Team < ActiveRecord::Base
  include AutoKeygen

  has_many :users
  has_many :projects

  validates :name, presence: true


end
