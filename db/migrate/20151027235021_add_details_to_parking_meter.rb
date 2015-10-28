class AddDetailsToParkingMeter < ActiveRecord::Migration
  def change
    add_column :parking_meters, :max_time, :float
    add_column :parking_meters, :name, :integer
  end
end
