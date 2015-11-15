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
        includes(:parking_meter).where("parking_meters.start_time < ? and parking_meters.end_time > ?", Time.now.seconds_since_midnight(), Time.now.seconds_since_midnight()).references(:parking_meters)
    end
end
