class ParkingMeter < ActiveRecord::Base
	validates :name, :price, presence: true
	has_one :lat_lon
	has_many :recent_meters
	has_many :users, :through => :recent_meters
end
