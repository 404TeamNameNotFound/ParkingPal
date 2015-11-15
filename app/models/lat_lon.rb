class LatLon < ActiveRecord::Base
	validates :lat,:lon,  presence: true
	validates :lat,:lon, numericality: true
	belongs_to :parking_meter

	def self.no_broken
        includes(:parking_meter).where("parking_meters.is_broken = ?", true).references(:parking_meters)
    end
end
