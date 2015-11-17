$(function() {
	$('#back-to-results').click(returnResults);
	$('.list-group-item').click(function() {
		var id = $(this).find('#results-meter-id').text();
		console.log(id);
		$.getJSON('/parking_meters/' + id + '.json', displayInfo);
	})
});

function onMarkerClick(marker, event){
	return function(event){
		$.getJSON('/parking_meters/' + marker.meter_id + '.json', displayInfo);
	}
}

function displayInfo(data) {
	console.log(data);
	$('#search-results').hide();

	$('#meter-name').text(data.name);
	$('#meter-price').text('$' + data.price);
	$('#meter-max-time').text(data.max_time + ' hrs');
	$('#meter-start-time').text(data.start_time);
	$('#meter.end-time').text(data.end_time);

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

	$('#meter-details').show();
}

function parseTime(time) {
	var timeArray = time.split('T')[1].split(':');
	return timeArray[0] + ':' + timeArray[1];
}

function returnResults() {
	$('#meter-details').hide();
	$('#search-results').show();
}