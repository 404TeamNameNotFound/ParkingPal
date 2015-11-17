
var current_marker;
var current_data

function onMarkerClick(marker, event){
	return function(event){
		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
		current_marker = marker;
	}
}

function displayInfo(data) {
	current_data = data;
	console.log(data);
	$('#search-results').hide();

	$('#meter-name').text(data.name);
	$('#meter-price').text('$' + data.price);
	$('#meter-max-time').text(data.max_time + ' hrs');
	$('#meter-start-time').text(data.start_time);
	$('#meter-end-time').text(data.end_time);

	$('#meter-broken').toggleClass('label-success', !data.is_broken);
	$('#meter-broken').toggleClass('label-danger', data.is_broken);
	if (data.is_broken) {
		$('#meter-broken').text('Broken');
	} else {
		$('#meter-broken').text('Not Broken');
	}

	$('#meter-occupied').toggleClass('label-success', !data.is_occupied);
	$('#meter-occupied').toggleClass('label-danger', data.is_occupied);
	if (data.is_occupied) {
		$('#meter-occupied').text('Occupied');
	} else {
		$('#meter-occupied').text('Not Occupied');
	}

	$('#tag-broken').prop('checked', data.is_broken);
	$('#tag-occupied').prop('checked', data.is_occupied);

	$('#meter-details').show();
}

function update_tag() {
	if (!current_data){
		return
	}

	var meterObject = createMeterObject(current_data);

	var color = "00FF00";
	if ($('#tag-broken').is(':checked')){
		color = "FF0000"
	} else if ($('#tag-occupied').is(':checked')){
		color = "0000FF"
	}

	if (current_marker) {
		current_marker.setIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|"+ color + "|000000");
	}

	var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

	$.ajaxSetup( {
		beforeSend: function ( xhr ) {
			xhr.setRequestHeader( 'X-CSRF-Token', token );
		}
	});

	$.ajax({
		data: meterObject,
		method: 'PATCH',
		url: '/update_meter'
	});

}

function createMeterObject(data) {
	return {
		id: data.id,
		parking_meter: {
			name: data.name,
			price: data.price,
			max_time: data.max_time,
			start_time: data.start_time,
			end_time: data.end_time,
			is_broken: $('#tag-broken').is(':checked'),
			is_occupied: $('#tag-occupied').is(':checked'),
			lat_lon: data.lat_lon
		}
	}
}

function parseTime(time) {
	var timeArray = time.split('T')[1].split(':');
	return timeArray[0] + ':' + timeArray[1];
}