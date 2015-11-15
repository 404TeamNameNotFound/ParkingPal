class ParkingMetersController < ApplicationController
  include ParkingMetersHelper
  # before_action :require_admin, only: [:destroy]
  before_action :set_parking_meter, only: [:show, :edit, :update, :destroy]

  # GET /parking_meters
  # GET /parking_meters.json
  def index
    @parking_meters = ParkingMeter.limit(2000)

    @hash = Gmaps4rails.build_markers(@parking_meters) do |meter, marker|
      marker.lat meter.lat_lon.lat
      marker.lng meter.lat_lon.lon
      marker.infowindow render_to_string(:partial => "infowindow", :locals => { :meter => meter})
    end
  end

  def parse
    clear_database
    parse_parking_meters
    flash[:notice] = "Parking Meters updated"
    redirect_to parking_meters_url
  end

  # GET /parking_meters/1
  # GET /parking_meters/1.json
  def show
    @parking_meter = ParkingMeter.includes(:lat_lon).find(params[:id])
    render json: @parking_meter.as_json(:include => { :lat_lon => { :only => [:lat, :lon]} })
  end

  # GET /parking_meters/new
  def new
    @parking_meter = ParkingMeter.new
  end

  # GET /parking_meters/1/edit
  def edit
  end
  
  # GET /edit
  def edit_arbitrary
  end

  # POST /parking_meters
  # POST /parking_meters.json
  def create
    @parking_meter = ParkingMeter.new(parking_meter_params)

    respond_to do |format|
      if @parking_meter.save
        format.html { redirect_to @parking_meter, notice: 'Parking meter was successfully created.' }
        format.json { render :show, status: :created, location: @parking_meter }
      else
        format.html { render :new }
        format.json { render json: @parking_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parking_meters/1
  # PATCH/PUT /parking_meters/1.json
  def update
    respond_to do |format|
      if @parking_meter.update(parking_meter_params)
        format.html { render :show, status: :ok, location: @parking_meter }
        # format.json { render :show, status: :ok, location: @parking_meter }
      else
        format.html { render :edit }
        format.json { render json: @parking_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parking_meters/1
  # DELETE /parking_meters/1.json
  def destroy
    @parking_meter.destroy
    respond_to do |format|
      format.html { redirect_to parking_meters_url, notice: 'Parking meter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parking_meter
      @parking_meter = ParkingMeter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parking_meter_params
      params.require(:parking_meter).permit(:meter_id, :price, :max_time, :start_time, :end_time, :credit_card, :phone, :is_broken, :is_occupied)
    end
end
