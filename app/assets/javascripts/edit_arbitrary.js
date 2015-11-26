$(function() {
	$('#fetch').click(fetchMeter);
	$('#submit').click(submit);
	$('#delete-confirm').click(deleteMeter);

	var coords;

});

function fetchMeter() {
	var id = $('#meter-id').val();
	$.getJSON('/parking_meters/' + id + '.json', updateForm).fail(function(jqxhr, textStatus, error) {
		$('#edit-danger').text("No such meter found.");
		$('#edit-danger').show();
		setTimeout(function() { $('#edit-danger').hide(); }, 5000);
	});
}

function updateForm(data) {
	coords = data.lat_lon;
	$('#parking_meter_id').val(data.id);
	$('#parking_meter_name').val(data.name);
	$('#parking_meter_price').val(data.price);
	$('#parking_meter_max_time').val(data.max_time);
	$('#parking_meter_start_time').val(data.start_time);
	$('#parking_meter_end_time').val(data.end_time);
	$('#parking_meter_is_broken').prop('checked', data.is_broken);
	$('#parking_meter_is_occupied').prop('checked', data.is_occupied);
}

function submit() {
	var meterObject = createMeterObject();

	var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

	$.ajaxSetup( {
		beforeSend: function ( xhr ) {
			xhr.setRequestHeader( 'X-CSRF-Token', token );
		}
	});

	$.ajax({
		data: meterObject,
		method: 'PATCH',
		url: '/parking_meters/' + meterObject.id + '.json',
		success: function() {
			$('#edit-alert').text("Edit successful.");
			$('#edit-alert').show();
			setTimeout(function() { $('#edit-alert').hide(); }, 5000);
		}
	});
}

function createMeterObject() {
	return {
		id: parseInt($('#parking_meter_id').val()),
		parking_meter: {
			name: $('#parking_meter_name').val(),
			price: $('#parking_meter_price').val(),
			max_time: $('#parking_meter_max_time').val(),
			start_time: $('#parking_meter_start_time').val(),
			end_time: $('#parking_meter_end_time').val(),
			is_broken: $('#parking_meter_is_broken').is(':checked'),
			is_occupied: $('#parking_meter_is_occupied').is(':checked'),
			lat_lon: coords
		}
	}
}

function toTime(time) {
	return '2000-01-01T' + time + ':00.000Z';
}

function deleteMeter() {
	var id = $('#parking_meter_id').val();
	var token = $( 'meta[name="csrf-token"]' ).attr( 'content' );

	$.ajaxSetup( {
		beforeSend: function ( xhr ) {
			xhr.setRequestHeader( 'X-CSRF-Token', token );
		}
	});

	$.ajax({
		data: {},
		method: 'DELETE',
		url: '/parking_meters/' + id + '.json',
		success: function() {
			$('#edit-alert').text("Delete successful.");
			$('#edit-alert').show();
			setTimeout(function() { $('#edit-alert').hide(); }, 5000);
		}
	});
}