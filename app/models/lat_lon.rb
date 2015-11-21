class LatLon < ActiveRecord::Base
	validates :lat,:lon,  presence: true
	validates :lat,:lon, numericality: true
	belongs_to :parking_meter

	def self.search(search)
		includes(:parking_meter).where("parking_meters.name LIKE ?", "%#{search}%").references(:parking_meters)
	end

	def self.closest_meter(location, radius)
		geocoded_location = Geocoder.coordinates(location)
		#includes(:parking_meter).near([geocoded_location], radius, :units => :km).references(:parking_meters)
		LatLon.near([geocoded_location], radius, :units => :km)
	end

	def self.current_location(location, radius)
		_latitude = request.location.latitude
		_longitude = request.location.longitude
		LatLon.near([_latitude, _longitude], radius, :units => :km)
	end

	def self.cheapest_meter
		includes(:parking_meter).where("parking_meters.price = ?", minimum("parking_meters.price")).references(:parking_meters)
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
