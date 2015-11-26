require 'zip'
require 'open-uri'

module ParkingMetersHelper

	def parse_test

		doc = Nokogiri::XML(File.open("#{Rails.root}/test/fixtures/test.kml")) do |config|
			config.strict.noblanks
		end
		doc.remove_namespaces!

		places = doc.xpath('.//Placemark')
		places.each do |meter|
			if meter.children.size == 4
				temp_meter = ParkingMeter.new
				lat_lon = LatLon.new
				lat_lon.parking_meter = temp_meter
				meter.children.each do |node|
					case node.node_name
					when 'name'
						temp_meter.name = node.text.to_i
					when 'description'
						parse_description(node, temp_meter)
					when 'Point'
						parse_point(node, temp_meter, lat_lon)
					end
				end
				lat_lon.save
				temp_meter.save
			end
		end
	end
	
	def parse_parking_meters
		url = 'http://data.vancouver.ca/download/kml/parking_meter_rates_and_time_limits.kmz'
		zip_file = open(url)

		unzip_folder = Zip::File.open(zip_file)
		kml = unzip_folder.read('parking_meter_rates_and_time_limits.kml')

		doc = Nokogiri::XML(kml) do |config|
			config.strict.noblanks
		end
		doc.remove_namespaces!
		
		places = doc.xpath('.//Placemark')
		places.each do |meter|
			if meter.children.size == 4
				temp_meter = ParkingMeter.new
				lat_lon = LatLon.new
				lat_lon.parking_meter = temp_meter
				meter.children.each do |node|
					case node.node_name
					when 'name'
						temp_meter.name = node.text.to_i
					when 'description'
						parse_description(node, temp_meter)
					when 'Point'
						parse_point(node, temp_meter, lat_lon)
					end
				end
				lat_lon.save
				temp_meter.save
			end
		end
	end

	def parse_description(node, temp_meter)
		array = node.text.split("<br>")
		array.each do |a|
			i = a.split(": ")
			case i.first
			when "Time Limit"
				temp_meter.max_time = i.last.delete(" Hr").to_f.abs
			when "Rate"
				temp_meter.price = i.last.delete("$").to_f.abs
			when "Time in Effect"
				begin 
					times = i.last.split(' TO ')
					if times.length >= 2
						temp_meter.start_time = Time.parse(times.first).seconds_since_midnight().to_i
						temp_meter.end_time = Time.parse(times.last).seconds_since_midnight().to_i
					else
						times = i.last.split(/-/)
						if times.length >= 2
							temp_meter.start_time = Time.parse(times.first).seconds_since_midnight().to_i
							temp_meter.end_time = Time.parse(times.last).seconds_since_midnight().to_i
						else
							temp_meter.start_time = Time.parse("0:00").seconds_since_midnight().to_i
							temp_meter.end_time = Time.parse(" 23:59:59").seconds_since_midnight().to_i
						end
					end
				rescue
				end
			end
		end
	end

	def parse_point(node, temp_meter, lat_lon)
		node.children.each do |coord|
			if coord.node_name.eql? 'coordinates'
				arr = coord.text.split(',')
				if arr.length > 1
					lat_lon.lat = BigDecimal(arr[1])
					lat_lon.lon = BigDecimal(arr[0])
				end
			end
		end	
	end

	def clear_database
		ParkingMeter.delete_all
		LatLon.delete_all
	end

end
