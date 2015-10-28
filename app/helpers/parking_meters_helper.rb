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
			temp_meter = ParkingMeter.new
			meter.children.each do |node|
				case node.node_name
				when 'name'
					temp_meter.name = node.text.to_i
				when 'description'
					parse_description(node, temp_meter)
				when 'point'
					parse_point(node, temp_meter)
				end
			end
			temp_meter.save
		end
	end

	def parse_description(node, temp_meter)
		array = node.text.split("<br>")
		arr.each do |a|
			i = a.split(": ")
			if i.first.eql? "Time Limit"
				temp_meter.max_time = i.last.delete(" Hr").to_f
			elsif i.first.eql? "Rate"
				temp_meter.price = i.last.delete("$").to_f
			elsif i.first.eql? "Time in Effect"
				times = i.last.split(' TO ')
				if times.length >= 2
					temp_meter.start_time = Time.parse(times.first)
					temp_meter.end_time = Time.parse(times.last)
				end
			end
		end
	end

	def parse_point(node, temp_meter)
		#STUB!!!
	end

end
