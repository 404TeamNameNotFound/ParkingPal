function onMarkerClick(marker, event){
	return function(event){
		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
	}
}

function displayInfo(data) {
	console.log(data);
}

function parseTime(time) {
	var timeArray = time.split('T')[1].split(':');
	return timeArray[0] + ':' + timeArray[1];
}

function makeListItem(marker) {
	return '<a href="#" class="list-group-item"><b>Parking Meter: </b>' + marker.meter_name + '</a>';
}