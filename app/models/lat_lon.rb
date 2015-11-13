class LatLon < ActiveRecord::Base
	validates :lat,:lon,  presence: true
	validates :lat,:lon, numericality: true
	belongs_to :parking_meter

	def self.search(search)
		where("parking_meter.name LIKE ?", "%{search}%")
	end
	
end
