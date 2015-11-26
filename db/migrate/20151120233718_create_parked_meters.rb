class CreateParkedMeters < ActiveRecord::Migration
  def change
    create_table :parked_meters do |t|
      t.datetime :time_left
      t.references :parking_meter, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
