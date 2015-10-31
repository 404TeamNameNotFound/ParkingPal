json.array!(@parking_meters) do |parking_meter|
  json.extract! parking_meter, :id, :meter_id, :price, :max_time, :start_time, :end_time, :credit_card, :phone, :is_broken, :is_occupied
  json.url parking_meter_url(parking_meter, format: :json)
end
