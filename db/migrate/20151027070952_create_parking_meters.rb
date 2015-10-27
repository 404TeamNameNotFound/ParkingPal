class CreateParkingMeters < ActiveRecord::Migration
  def change
    create_table :parking_meters do |t|
      t.integer :meter_id
      t.float :price
      t.time :max_time
      t.time :start_time
      t.time :end_time
      t.boolean :credit_card
      t.boolean :phone
      t.boolean :is_broken
      t.boolean :is_occupied

      t.timestamps null: false
    end
  end
end
