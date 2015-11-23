require 'zip'
require 'open-uri'

module ParkingMetersHelper
	
	def parse_parking_meters
		url = 'http://data.vancouver.ca/download/kml/parking_meter_rates_and_time_limits.kmz'
		zip_file = open(url)

		unzip_folder = Zip::File.open(zip_file)
		kml = unzip_folder.read('parking_meter_rates_and_time_limits.kml')

		doc = Nokogiri::XML(kml)
		doc.remove_namespaces!

		places = doc.xpath('.//Placemark')
		places.each do |meter|
			if meter.children.size == 9
			temp_meter = ParkingMeter.new
			meter.children.each do |node|
				case node.node_name
				when 'name'
					temp_meter.name = node.text.to_i
				when 'description'
					parse_description(node, temp_meter)
				when 'Point'
					parse_point(node, temp_meter)
				end
			end
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
				temp_meter.max_time = i.last.delete(" Hr").to_f
			when "Rate"
				temp_meter.price = i.last.delete("$").to_f
			when "Time in Effect"
				times = i.last.split(' TO ')
				if times.length >= 2
					temp_meter.start_time = Time.parse(times.first).seconds_since_midnight()
					temp_meter.end_time = Time.parse(times.last).seconds_since_midnight()
				else
					times = i.last.split(/-/)
					if times.length >= 2
						temp_meter.start_time = Time.parse(times.first).seconds_since_midnight()
						temp_meter.end_time = Time.parse(times.last).seconds_since_midnight()
					else
						temp_meter.start_time = Time.parse("0:00").seconds_since_midnight()
						temp_meter.end_time = Time.parse(" 23:59:59.999999").seconds_since_midnight()
					end
				end
			end
		end
	end

	def parse_point(node, temp_meter)
		node.children.each do |coord|
			if coord.node_name.eql? 'coordinates'
				lat_lon = LatLon.new
				lat_lon.parking_meter = temp_meter
				arr = coord.text.split(',')
				lat_lon.lat = BigDecimal(arr[1])
				lat_lon.lon = BigDecimal(arr[0])
				lat_lon.save
			end
		end
	end

	def clear_database
		ParkingMeter.delete_all
		LatLon.delete_all
	end

end
