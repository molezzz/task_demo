# 简单加个cache，实际中最好用套娃缓存
json.cache! @cache_key, expires_in: 1.minutes do
  json.array! @events do |event|
    json.extract! event, :id, :kind, :created_at
    json.user do
      json.extract! event.source, :id, :name, :key
    end
    json.project do
      project = event.eventable.try(:project)
      json.extract! project, :key, :title if project
    end
    #处理局部模板
    #json.partial! path, event: event
    path = event.kind.gsub('.','/')
    json.html render locals: { event: event }, partial: "events/#{path}", formats: [:html]
  end
end