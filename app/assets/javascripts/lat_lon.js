var currentMarker;
var currentData;
var resultClicked = false;

$(function() {
	$('#back-to-results').click(returnResults);
	$('.list-group-item').click(function() {
		var id = $(this).find('#results-meter-id').text();
		console.log(id);
		$.getJSON('/parking_meters/' + id + '.json', displayInfo);
	})
});

function setMarkerSize(marker, size) {
	var icon = marker.getIcon();
	icon.size = size;
	icon.scaledSize = size;
	marker.setIcon(icon);
}

function setMarkerColor(marker, broken, occupied) {
	var color = "18bc9c";
	if (broken){
		color = "e74c3c"
	} else if (occupied){
		color = "3498db"
	}

	var icon = marker.getIcon();
	icon.url = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|"+ color + "|000000";
	marker.setIcon(icon);

	markers[marker.index].picture.url = icon.url;
	console.log(marker.index);
}

function createSearchResult(meter, number) {
	return ('<button type="button" class="list-group-item search-result-item"><b> '+ number +'. &emsp; Meter No. </b><span id="results-meter-id">' 
		+ meter.serviceObject.meter_name + '</span></button>');
}

function bindResultToMarker($result, marker) {
	$result.click(function() {
		resultClicked = true;
		handler.getMap().setZoom(19);
		marker.setMap(handler.getMap());
		marker.panTo();
		google.maps.event.trigger(marker.getServiceObject(), 'click');
	})
	$result.mouseover(function() {
		setMarkerSize(marker.getServiceObject(), new google.maps.Size(34, 50));
		marker.getServiceObject().setZIndex(google.maps.Marker.MAX_ZINDEX);
	})
	$result.mouseleave(function() {
		if (resultClicked) return;
		setMarkerSize(marker.getServiceObject(), new google.maps.Size(21, 34));
		marker.getServiceObject().setZIndex(undefined);
	})
}

function populateSearchResults(markers, index) {
	console.log(markers)
	if (markers.length == 0) {
		var $empty = $('<div class="well">No meters to display.</div>');
		$empty.appendTo('#search-results-list');
	}
	for (var i=0; i<markers.length; i++) {
		var $result = $(createSearchResult(markers[i], index+i+1));
		$result.appendTo('#search-results-list');
		bindResultToMarker($result, markers[i]);
	}
}

function onMarkerClick(marker, event){
	return function(event){
		var selectedSize = new google.maps.Size(34, 50);
		var regularSize = new google.maps.Size(21, 34);

		if(currentMarker) {
			setMarkerSize(currentMarker, regularSize);
			currentMarker.setZIndex(undefined);
		}

		setMarkerSize(marker, selectedSize);
		marker.setZIndex(google.maps.Marker.MAX_ZINDEX);

		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
		console.log('click', marker);
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
	$('#meter-occupied').toggleClass('label-info', occupied);
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
	$('#meter-max-time').text(data.max_time == 0? "No Time Limit" : data.max_time + ' hrs');
	$('#meter-start-time').text(parseTime(data.start_time));
	$('#meter-end-time').text(parseTime(data.end_time));

	toggleBrokenOccupiedLabels(data.is_broken, data.is_occupied);

	$("#fb-share-link").attr("href", "https://www.facebook.com/sharer/sharer.php?u=https://pacific-coast-2326.herokuapp.com/lat_lons?search="+data.name);

	$('#meter-details').show();
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
	var hours = Math.floor(timeInMins / 60);
	var mins = Math.floor(timeInMins % 60);
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

function populateMap(handler, markers, coords, index) {
	handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){

		Gmaps.store = {}
		Gmaps.store.markers = markers.map(function(m, i) {
			marker = handler.addMarker(m);
			marker.serviceObject.set('meter_id', m.meter_id);
			marker.serviceObject.set('meter_name', m.meter_name);
			marker.serviceObject.set('index', i+index);
			return marker;
		});

		if (coords.length != 0) {
			handler.addMarker({
				lat: coords[0],
				lng: coords[1],
				picture: {
					url: "http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=star|f39c12|000000",
					width:  28,
					height: 45
				}
			});
		} else {
			
			if(navigator.geolocation)
				navigator.geolocation.getCurrentPosition(displayOnMap);

			function displayOnMap(position){
				var marker = handler.addMarker({
					lat: position.coords.latitude,
					lng: position.coords.longitude,
					picture: {
						url: "http://chart.apis.google.com/chart?chst=d_map_pin_icon&chld=star|f39c12|000000",
						width:  28,
						height: 45
					}
				});
			}
		}


		if (markers.length == 0) {
			var centerpoint = new google.maps.LatLng(49.240021, -123.091008);
			handler.map.centerOn(centerpoint);
			handler.getMap().setZoom(12);
		}

		handler.bounds.extendWith(Gmaps.store.markers);
		handler.fitMapToBounds();

		for (var i = 0; i <  Gmaps.store.markers.length; ++i) {
			var marker = Gmaps.store.markers[i];
			google.maps.event.addListener(marker.serviceObject, 'click', onMarkerClick(marker.serviceObject, window.event));
		}

		populateSearchResults(Gmaps.store.markers, index);

	});
}

function clearMapList(handler) {
	handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
	});
	$('.search-result-item').remove()
}