function onMarkerClick(marker, event){
	return function(event){
		$.getJSON('/parking_meters/' + marker.id + '.json', displayInfo);
	}
}

function displayInfo(data) {
	console.log(data);
}

function parseTime(time) {
	var timeArray = time.split('T')[1].split(':');
	return timeArray[0] + ':' + timeArray[1];
}