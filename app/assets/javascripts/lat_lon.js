var currentMarker;
var currentData;

$(function() {
	$('#back-to-results').click(returnResults);
	$('.list-group-item').click(function() {
		var id = $(this).find('#results-meter-id').text();
		console.log(id);
		$.getJSON('/parking_meters/' + id + '.json', displayInfo);
	})
});

function createSearchResult(meter) {
	return ('<button type="button" class="list-group-item"><b> Meter No. </b><span id="results-meter-id">' 
		+ meter.serviceObject.meter_name + '</span></button>');
}

function bindResultToMarker($result, marker) {
	$result.click( function() {
		handler.getMap().setZoom(16);
		marker.setMap(handler.getMap());
		marker.panTo();
		google.maps.event.trigger(marker.getServiceObject(), 'click');
	})
}

function populateSearchResults(markers) {
	for (var i=0; i<markers.length; i++) {
		var $result = $(createSearchResult(markers[i]));
		$result.appendTo('#search-results-list');
		bindResultToMarker($result, markers[i]);
	}
}

function onMarkerClick(marker, event){
	return function(event){
		var selectedSize = new google.maps.Size(28, 45);
		var regularSize = new google.maps.Size(21, 34);

		if(currentMarker) {
			var oldSelectedIcon = currentMarker.getIcon();
			oldSelectedIcon.size = regularSize;
			oldSelectedIcon.scaledSize = regularSize;
			currentMarker.setIcon(oldSelectedIcon);
			currentMarker.setZIndex(undefined);
		}

		var icon = marker.getIcon();
		icon.size = new google.maps.Size(25, 40);
		icon.scaledSize = new google.maps.Size(25, 40);
		marker.setIcon(icon);
		marker.setZIndex(google.maps.Marker.MAX_ZINDEX);

		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
		currentMarker = marker;
	}
}

function displayInfo(data) {
	currentData = data;
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
	if (!currentData){
		return
	}

	var meterObject = createMeterObject(currentData);

	var color = "00FF00";
	if ($('#tag-broken').is(':checked')){
		color = "FF0000"
	} else if ($('#tag-occupied').is(':checked')){
		color = "0000FF"
	}

	if (currentMarker) {
		currentMarker.setIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|"+ color + "|000000");
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

function returnResults() {
	$('#meter-details').hide();
	$('#search-results').show();
}