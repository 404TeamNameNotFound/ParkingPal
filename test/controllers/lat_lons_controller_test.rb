require 'test_helper'

class LatLonsControllerTest < ActionController::TestCase
  setup do
    @lat_lon = lat_lons(:ll_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lat_lons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lat_lon" do
    assert_difference('LatLon.count') do
      post :create, lat_lon: { lat: @lat_lon.lat, lon: @lat_lon.lon, parking_meter_id: @lat_lon.parking_meter_id }
    end

    assert_redirected_to lat_lon_path(assigns(:lat_lon))
  end

  test "should show lat_lon" do
    get :show, id: @lat_lon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lat_lon
    assert_response :success
  end

  test "should update lat_lon" do
    patch :update, id: @lat_lon, lat_lon: { lat: @lat_lon.lat, lon: @lat_lon.lon, parking_meter_id: @lat_lon.parking_meter_id }
    assert_redirected_to lat_lon_path(assigns(:lat_lon))
  end

  test "should destroy lat_lon" do
    assert_difference('LatLon.count', -1) do
      delete :destroy, id: @lat_lon
    end

    assert_redirected_to lat_lons_path
  end

end
