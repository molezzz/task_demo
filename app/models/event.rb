class Event < ActiveRecord::Base
  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  belongs_to :todo, ->{ where(target: 'Todo')}, foreign_key: 'target_id'

end
