json.array!(@users) do |user|
  json.extract! user, :id, :latitude, :longitude, :address, :description, :titlestring
  json.url user_url(user, format: :json)
end
