var currentMarker;
var currentData;
var resultClicked = false;
var userId


$(function() {
	$('#back-to-results').click(returnResults);
	// $('.list-group-item').click(function() {
	// 	var id = $(this).find('#results-meter-id').text();
	// 	console.log(id);
	// 	$.getJSON('/parking_meters/' + id + '.json', displayInfo);
	// })
	$('#save-meter').click(function(e) {
		e.stopImmediatePropagation(); // stop from firing twice
		saveMeter();
	});
});

function displayAlert(element, type, text) {
	var childAlert = $(element + ' > .alert:first');
	if (childAlert.length > 0) {
		if (childAlert.hasClass(type)) {
			childAlert.text(text);
			return;
		}
		childAlert.remove();
	}
	var alert = '<div class="alert ' + type + '" role="alert">' + text + '</div>';
	$(element).prepend(alert);
}

function setMarkerSize(marker, size) {
	var icon = marker.getIcon();
	icon.size = size;
	icon.scaledSize = size;
	marker.setIcon(icon);
}

function setMarkerColor(marker, broken, occupied) {
	var color = "00FF00";
	if (broken){
		color = "FF0000"
	} else if (occupied){
		color = "0000FF"
	}

	var icon = marker.getIcon();
	icon.url = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|"+ color + "|000000";
	marker.setIcon(icon);
}

function createSearchResult(meter) {
	return ('<button type="button" class="list-group-item"><b> Meter No. </b><span id="results-meter-id">' 
		+ meter.serviceObject.meter_name + '</span></button>');
}

function bindResultToMarker($result, marker) {
	$result.click(function() {
		resultClicked = true;
		handler.getMap().setZoom(16);
		marker.setMap(handler.getMap());
		marker.panTo();
		google.maps.event.trigger(marker.getServiceObject(), 'click');
	})
	$result.mouseover(function() {
		setMarkerSize(marker.getServiceObject(), new google.maps.Size(28, 45));
		marker.getServiceObject().setZIndex(google.maps.Marker.MAX_ZINDEX);
	})
	$result.mouseleave(function() {
		if (resultClicked) return;
		setMarkerSize(marker.getServiceObject(), new google.maps.Size(21, 34));
		marker.getServiceObject().setZIndex(undefined);
	})
}

function populateSearchResults(markers) {
	console.log(markers)
	if (markers.length == 0) {
		var $empty = $('<div class="well">No meters to display.</div>');
		$empty.appendTo('#search-results-list');
	}
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
			setMarkerSize(currentMarker, regularSize);
			currentMarker.setZIndex(undefined);
		}

		setMarkerSize(marker, selectedSize);
		marker.setZIndex(google.maps.Marker.MAX_ZINDEX);

		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
		currentMarker = marker;
	}
}

function toggleBrokenOccupiedLabels(broken, occupied) {
	$('#meter-broken').toggleClass('label-success', !broken);
	$('#meter-broken').toggleClass('label-danger', broken);
	if (broken) {
		$('#meter-broken').text('Broken');
	} else {
		$('#meter-broken').text('Not Broken');
	}

	$('#meter-occupied').toggleClass('label-success', !occupied);
	$('#meter-occupied').toggleClass('label-danger', occupied);
	if (occupied) {
		$('#meter-occupied').text('Occupied');
	} else {
		$('#meter-occupied').text('Not Occupied');
	}

	$('#tag-broken').prop('checked', broken);
	$('#tag-occupied').prop('checked', occupied);
}

function displayInfo(data) {
	currentData = data;
	console.log(data);
	$('#search-results').hide();

	$('#meter-name').text(data.name);
	$('#meter-price').text('$' + data.price);
	$('#meter-max-time').text(data.max_time + ' hrs');
	$('#meter-start-time').text(parseTime(data.start_time));
	$('#meter-end-time').text(parseTime(data.end_time));

	toggleBrokenOccupiedLabels(data.is_broken, data.is_occupied);

	$('#meter-details').show();

	if (userId) {
		addRecent(data.id);
	}
}

function addRecent(id) {
	var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

	$.ajaxSetup( {
		beforeSend: function ( xhr ) {
			xhr.setRequestHeader( 'X-CSRF-Token', token );
		}
	});

	$.ajax({
		data: {},
		method: 'PATCH',
		url: '/add_recent/' + id + '.json'
	});
}

function updateTag(changedType) {
	if (!currentData){
		return
	}

	if (changedType == 'broken') {
		currentData.is_broken = !currentData.is_broken;
		var meterObject = createMeterObject(currentData);
	} else if (changedType == 'occupied') {
		currentData.is_occupied = !currentData.is_occupied;
		var meterObject = createMeterObject(currentData);
	} else return;

	toggleBrokenOccupiedLabels(meterObject.parking_meter.is_broken, meterObject.parking_meter.is_occupied);

	if (currentMarker) {
		setMarkerColor(currentMarker, meterObject.parking_meter.is_broken, meterObject.parking_meter.is_occupied);
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
			is_broken: data.is_broken,
			is_occupied: data.is_occupied,
			lat_lon: data.lat_lon
		}
	}
}

function parseTime(time) {
	var timeInMins = time / 60;
	var hours = timeInMins / 60;
	var mins = timeInMins % 60;
	var hoursString = (hours < 10) ? ('0' + hours) : hours;
	var minsString = (mins < 10) ? ('0' + mins) : mins;
	return hoursString + ':' + minsString;
}

function returnResults() {
	resultClicked = false;
	$('#meter-details').hide();
	$('#search-results').show();
	setMarkerSize(currentMarker, new google.maps.Size(21, 34));
}

function floatHoursToMins(max_time) {
	var str = max_time.toFixed(1);
	var strArray = str.split(".");
	var totalMins = strArray[0] * 60;
	if (strArray.length > 1) {
		totalMins += parseInt(strArray[1]);
	}
	return totalMins;
}

function saveMeter() {
	var hours = parseInt($('#save-meter-hours').val());
	var minutes = parseInt($('#save-meter-minutes').val());

	if (isNaN(hours) || isNaN(minutes)) {
		displayAlert('#save-meter-modal-body', 'alert-danger', 'You must enter hours and minutes.');
		return;
	}

	var totalMins = hours * 60 + minutes;
	var maxTimeMins = floatHoursToMins(currentData.max_time);

	if (totalMins > maxTimeMins) {
		displayAlert('#save-meter-modal-body', 'alert-danger', "Exceeds meter's max time (" + currentData.max_time + " hrs)");
		return;
	}

	var currentTime = new Date();
	currentTime.setHours(currentTime.getHours() + hours);
	currentTime.setMinutes(currentTime.getMinutes() + minutes);

	console.log(currentTime);

	var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

	$.ajaxSetup( {
		beforeSend: function ( xhr ) {
			xhr.setRequestHeader( 'X-CSRF-Token', token );
		}
	});

	// var userId = <%= current_user.id %>

	$.ajax({
		data: { parked_meter: {time_left: currentTime.getTime(), parking_meter_id: currentData.id} },
		method: 'PATCH',
		url: '/users/' + userId + '/parked_meters/' + currentData.id + '.json',
		success: function() {
			updateTag('occupied');
			displayAlert('#save-meter-modal-body', 'alert-success', 'Success');
		}
	})

	
}