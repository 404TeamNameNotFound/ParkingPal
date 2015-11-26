require 'test_helper'

class ParkingMeterTest < ActiveSupport::TestCase
	include ParkingMetersHelper

  test "parse skip missing args" do
    parse_test
    assert_equal(10, ParkingMeter.count)
  end

  test "parse neg vaues" do
  	parse_test
    assert_equal(10, ParkingMeter.count)
    assert_equal(5, ParkingMeter.where(name: 55555).first.max_time)
    assert_equal(8, ParkingMeter.where(name: 66666).first.price)
  end

  test "parse bad details" do
  	parse_test
    assert_equal(10, ParkingMeter.count)
    assert_equal(0, ParkingMeter.where(name: 77777).first.max_time)
    assert_equal(0, ParkingMeter.where(name: 88888).first.start_time)
    assert_equal(86399, ParkingMeter.where(name: 88888).first.end_time)

    assert_equal(0, ParkingMeter.where(name: 99999).first.max_time)
    assert_equal(0, ParkingMeter.where(name: 99999).first.price)
    assert_equal(0, ParkingMeter.where(name: 99999).first.start_time)
    assert_equal(86399, ParkingMeter.where(name: 99999).first.end_time)
  end

  test "parse bad coords" do
  	parse_test
    assert_equal(10, ParkingMeter.count)

    assert_equal(0, ParkingMeter.where(name: 00000).first.lat_lon.lat)
    assert_equal(0, ParkingMeter.where(name: 00000).first.lat_lon.lon)

    assert_equal(0, ParkingMeter.where(name: 88888).first.lat_lon.lat)
    assert_equal(0, ParkingMeter.where(name: 88888).first.lat_lon.lon)

    assert_equal(2, ParkingMeter.where(name: 99999).first.lat_lon.lat)
    assert_equal(1, ParkingMeter.where(name: 99999).first.lat_lon.lon)
  end


end
