json.array!(@accesses) do |access|
  json.extract! access, :id, :user_id, :project_id
  json.url access_url(access, format: :json)
end
