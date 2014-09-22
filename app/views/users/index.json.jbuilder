json.array!(@users) do |user|
  json.extract! user, :id, :key, :team_id, :name, :email, :avatar
  json.url user_url(user, format: :json)
end
