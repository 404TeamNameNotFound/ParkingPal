class LatLon < ActiveRecord::Base
	validates :lat,:lon,  presence: true
	validates :lat,:lon, numericality: true
	belongs_to :parking_meter

	def self.no_broken
        includes(:parking_meter).where("parking_meters.is_broken = ?", true).references(:parking_meters)
    end

    def self.no_occupied
        includes(:parking_meter).where("parking_meters.is_occupied = ?", true).references(:parking_meters)
    end

    def self.no_after_hours
        includes(:parking_meter).where("parking_meters.start_time < ? and parking_meters.end_time > ?", Time.now.change(year: 2000, month: 1, day: 1), Time.now.change(year: 2000, month: 1, day: 1)).references(:parking_meters)
    end
end
