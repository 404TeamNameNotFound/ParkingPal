class LatLon < ActiveRecord::Base
	acts_as_mappable :default_units => :meters,
									 :default_formula => :flat,
									 :distance_field_name => :distance,
									 :lat_column_name => :lat,
									 :lng_column_name => :lon

	validates :lat,:lon,  presence: true
	validates :lat,:lon, numericality: true
	belongs_to :parking_meter

	def self.search(search)
		includes(:parking_meter).where("parking_meters.name LIKE ?", "%#{search}%").references(:parking_meters)
	end

	def self.order_by_cheapest
		includes(:parking_meter).order('parking_meters.price ASC')
	end

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

