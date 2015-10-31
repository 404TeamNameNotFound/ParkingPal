json.array!(@lat_lons) do |lat_lon|
  json.extract! lat_lon, :id, :lat, :lon, :parking_meter_id
  json.url lat_lon_url(lat_lon, format: :json)
end
