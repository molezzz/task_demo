json.array!(@events) do |event|
  json.extract! event, :id, :kind, :source_id, :target, :target_id, :data
  json.url event_url(event, format: :json)
end
