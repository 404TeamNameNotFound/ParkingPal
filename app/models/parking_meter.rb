class ParkingMeter < ActiveRecord::Base
	validates :name, :price, presence: true
	has_one :lat_lon
end
