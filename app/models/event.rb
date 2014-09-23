class Event < ActiveRecord::Base
  belongs_to :source, class_name: 'User', foreign_key: 'source_id'

end
