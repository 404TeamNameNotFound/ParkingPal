json.array!(@parked_meters) do |parked_meter|
  json.extract! parked_meter, :id, :time_left, :parking_meter_id
  json.url parked_meter_url(parked_meter, format: :json)
end
