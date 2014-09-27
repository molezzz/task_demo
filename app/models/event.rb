class Event < ActiveRecord::Base
  store :data, accessors: [:target_snap, :attr, :from, :to, :title, :content] ,coder: JSON

  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  #note 关联关系由MonitorWithEvent自动生成
  #belongs_to :todo, ->{ where(target: 'Todo')}, foreign_key: 'target_id'


end
