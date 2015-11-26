class CreateRecentMeters < ActiveRecord::Migration
  def change
    create_table :recent_meters do |t|
      t.integer :user_id
      t.integer :parking_meter_id
      
      t.timestamps null: false
    end
  end
end
