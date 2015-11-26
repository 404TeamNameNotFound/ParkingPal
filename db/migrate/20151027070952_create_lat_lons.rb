class CreateLatLons < ActiveRecord::Migration
  def change
    create_table :lat_lons do |t|
      t.decimal  :lat,  :precision => 15, :scale => 10, :default => 0.0
      t.decimal  :lon, :precision => 15, :scale => 10, :default => 0.0
      t.references :parking_meter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
