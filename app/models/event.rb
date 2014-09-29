class Event < ActiveRecord::Base
  store :data, accessors: [:target_snap, :attr, :from, :to, :asso] ,coder: JSON

  belongs_to :source, class_name: 'User', foreign_key: 'source_id'

  #特殊设置为了兼容原来的数据格式
  belongs_to :eventable, foreign_key: 'target_id', foreign_type: 'target', polymorphic: true


end
