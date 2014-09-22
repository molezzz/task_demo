json.array!(@projects) do |project|
  json.extract! project, :id, :key, :title, :team_id
  json.url project_url(project, format: :json)
end
