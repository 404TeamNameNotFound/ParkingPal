class ParkingMeter < ActiveRecord::Base
	validates :name, :price, presence: true
	has_one :lat_lon
	has_many :recent_meters
	has_many :users, :through => :recent_meters

	def unoccupy
		self.is_occupied = false
		if self.save
			puts 'Successfully unoccupied parking meter #' + self.name.to_s
			return true
		else
			puts 'Failed to unoccupy parking meter #' + self.name.to_s
			return false
		end
	end
end
