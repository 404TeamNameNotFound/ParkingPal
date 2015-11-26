class CreateParkingMeters < ActiveRecord::Migration
  def change
    create_table :parking_meters do |t|
      t.integer :name, :default => 0
      t.float :price, :default => 0
      t.float :max_time, :default => 0
      t.integer :start_time, :default => 0
      t.integer :end_time, :default => 86399
      t.boolean :is_broken, :default => false
      t.boolean :is_occupied, :default => false

      t.timestamps null: false
    end
  end
end
