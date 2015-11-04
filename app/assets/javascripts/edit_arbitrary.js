$(function() {
	$('#fetch').click(fetchMeter);
	$('#submit').click(submit);

	var coords;

	function fetchMeter() {
		var id = $('#meter-id').val();
		$.getJSON('/parking_meters/' + id + '.json', updateForm);
	}

	function updateForm(data) {
		coords = data.lat_lon;
		var startTime = parseTime(data.start_time);
		var endTime = parseTime(data.end_time);
		$('#parking_meter_id').val(data.id);
		$('#parking_meter_name').val(data.name);
		$('#parking_meter_price').val(data.price);
		$('#parking_meter_max_time').val(data.max_time);
		$('#parking_meter_start_time').val(startTime);
		$('#parking_meter_end_time').val(endTime);
		$('#parking_meter_is_broken').prop('checked', data.is_broken);
		$('#parking_meter_is_occupied').prop('checked', data.is_occupied);
	}

	function parseTime(time) {
		var timeArray = time.split('T')[1].split(':');
		return timeArray[0] + ':' + timeArray[1];
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
			url: '/update_meter'
		});
	}

	function createMeterObject() {
		return {
			id: parseInt($('#parking_meter_id').val()),
			parking_meter: {
				name: parseInt($('#parking_meter_name').val()),
				price: parseInt($('#parking_meter_price').val()),
				max_time: parseInt($('#parking_meter_max_time').val()),
				start_time: toTime($('#parking_meter_start_time').val()),
				end_time: toTime($('#parking_meter_end_time').val()),
				is_broken: $('#parking_meter_is_broken').is(':checked'),
				is_occupied: $('#parking_meter_is_occupied').is(':checked'),
				lat_lon: coords
			}
		}
	}

	function toTime(time) {
		return '2000-01-01T' + time + ':00.000Z';
	}
})