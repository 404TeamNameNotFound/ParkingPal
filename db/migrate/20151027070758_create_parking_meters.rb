class CreateParkingMeters < ActiveRecord::Migration
  def change
    create_table :parking_meters do |t|
      t.integer :name
      t.float :price
      t.float :max_time
      t.integer :start_time
      t.integer :end_time
      t.boolean :is_broken, :default => false
      t.boolean :is_occupied, :default => false

      t.timestamps null: false
    end
  end
end