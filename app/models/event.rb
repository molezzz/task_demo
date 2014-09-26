class Event < ActiveRecord::Base
  store :data, accessors: [:target_snap, :attr, :from, :to] ,coder: JSON

  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  belongs_to :todo, ->{ where(target: 'Todo')}, foreign_key: 'target_id'


end
