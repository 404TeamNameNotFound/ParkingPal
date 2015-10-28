class RemoveDetailsFromParkingMeter < ActiveRecord::Migration
  def change
    remove_column :parking_meters, :credit_card, :boolean
    remove_column :parking_meters, :phone, :boolean
    remove_column :parking_meters, :meter_id, :integer
    remove_column :parking_meters, :max_time, :time
  end
end
