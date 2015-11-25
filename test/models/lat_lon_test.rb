require 'test_helper'

class LatLonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "test association" do
  	p = ParkingMeter.create(:name => 55555, :price => 2, :max_time => 2, :start_time => 0, :end_time => 1000, :is_occupied => false, :is_broken => true)
  	l = LatLon.create(:lat => 4, :lon => 4)
  	l.parking_meter = p

  	assert_equal(l.parking_meter_id, p.id)
  	assert_equal(l.parking_meter.name, 55555)
  	assert_equal(l.parking_meter.price, 2)
  	assert_equal(l.parking_meter.start_time, 0)
  	assert_equal(l.parking_meter.end_time, 1000)
  	assert_equal(l.parking_meter.is_occupied, false)
  	assert_equal(l.parking_meter.is_broken, true)
  end

  test "filter no broken" do
  	@broken = ParkingMeter.create(:name => 55555, :price => 2, :max_time => 2, :start_time => 0, :end_time => 1000, :is_occupied => false, :is_broken => true)
  	@broken_ll = LatLon.create(:lat => 4, :lon => 4)
  	@broken_ll.parking_meter = @broken
  	@not_broken = ParkingMeter.create(:name => 55555, :price => 2, :max_time => 2, :start_time => 0, :end_time => 1000, :is_occupied => false, :is_broken => false)
  	@not_broken_ll = LatLon.create(:lat => 4, :lon => 4)
  	@not_broken_ll.parking_meter = @not_broken

  	assert_equal(6, LatLon.count)
  	assert_equal(3, ParkingMeter.where(:is_broken => false).count)
  end

  test "filter no occupied" do
  	assert_equal(LatLon.count, 4)
  	assert_equal(2, ParkingMeter.where(:is_occupied => false).count)
  end

  test "filter no after hours" do
  	assert_equal(LatLon.count, 4)
  	assert_equal(4, ParkingMeter.where("start_time < ? and end_time > ?", Time.parse("1:00 PM").seconds_since_midnight(), Time.parse("1:00 PM").seconds_since_midnight()).count)

  	assert_equal(1, ParkingMeter.where("start_time < ? and end_time > ?", Time.parse("1:00 AM").seconds_since_midnight(), Time.parse("1:00 AM").seconds_since_midnight()).count)
	end

	test "search meter id" do
		assert_equal(parking_meters(:pm_one), ParkingMeter.where("CAST(parking_meters.name as TEXT) LIKE ?", "%#{11111}%").first)
		assert_equal(parking_meters(:pm_two), ParkingMeter.where("CAST(parking_meters.name as TEXT) LIKE ?", "%#{22222}%").first)
		assert_equal(parking_meters(:pm_three), ParkingMeter.where("CAST(parking_meters.name as TEXT) LIKE ?", "%#{33333}%").first)
	end

	test "cheapest meter" do
		assert_equal(parking_meters(:pm_one), ParkingMeter.order('parking_meters.price ASC').first)
		assert_equal(parking_meters(:pm_three), ParkingMeter.order('parking_meters.price ASC').second)
		assert_equal(parking_meters(:pm_four), ParkingMeter.order('parking_meters.price ASC').third)
		assert_equal(parking_meters(:pm_two), ParkingMeter.order('parking_meters.price ASC').last)
	end

end
