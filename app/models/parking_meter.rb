class ParkingMeter < ActiveRecord::Base
	validates :name, :price, presence: true
	has_one :lat_lon

	def self.search(search)
		where("name LIKE ?", "%{search}%")
	end

end
