require 'test_helper'

class ParkingMetersControllerTest < ActionController::TestCase
  setup do
    @parking_meter = parking_meters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parking_meters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parking_meter" do
    assert_difference('ParkingMeter.count') do
      post :create, parking_meter: { credit_card: @parking_meter.credit_card, end_time: @parking_meter.end_time, is_broken: @parking_meter.is_broken, is_occupied: @parking_meter.is_occupied, max_time: @parking_meter.max_time, meter_id: @parking_meter.meter_id, phone: @parking_meter.phone, price: @parking_meter.price, start_time: @parking_meter.start_time }
    end

    assert_redirected_to parking_meter_path(assigns(:parking_meter))
  end

  test "should show parking_meter" do
    get :show, id: @parking_meter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parking_meter
    assert_response :success
  end

  test "should update parking_meter" do
    patch :update, id: @parking_meter, parking_meter: { credit_card: @parking_meter.credit_card, end_time: @parking_meter.end_time, is_broken: @parking_meter.is_broken, is_occupied: @parking_meter.is_occupied, max_time: @parking_meter.max_time, meter_id: @parking_meter.meter_id, phone: @parking_meter.phone, price: @parking_meter.price, start_time: @parking_meter.start_time }
    assert_redirected_to parking_meter_path(assigns(:parking_meter))
  end

  test "should destroy parking_meter" do
    assert_difference('ParkingMeter.count', -1) do
      delete :destroy, id: @parking_meter
    end

    assert_redirected_to parking_meters_path
  end
end