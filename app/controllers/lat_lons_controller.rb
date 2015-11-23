class LatLonsController < ApplicationController
  # before_action :require_admin

  before_action :set_lat_lon, only: [:show, :edit, :update, :destroy]


  # GET /lat_lons
  # GET /lat_lons.json
  def index

    @lat_lons = LatLon.where(nil)

    if params[:search]
      @lat_lons = @lat_lons.search(params[:search])
    end

    if (params[:location].present? && params[:radius].present?)
      @lat_lons = @lat_lons.within(params[:radius], :origin => params[:location])
    end

    if (params[:current_location].present? && params[:radius].present?)
      _lat = request.location.latitude
      _lon = request.location.longitude
      @lat_lons = @lat_lons.within(params[:radius], :origin => [_lat, _lon])
    end

    case params[:search_type]
    when "cheapest"
      @lat_lons = @lat_lons.order_by_cheapest
    when "closest"
      @lat_lons = @lat_lons.by_distance(:origin => params[:location])
    end

    @lat_lons = @lat_lons.no_broken if params[:no_broken].present?
    @lat_lons = @lat_lons.no_occupied if params[:no_occupied].present?
    @lat_lons = @lat_lons.no_after_hours if params[:no_after_hours].present?

    @hash = Gmaps4rails.build_markers(@lat_lons) do |lat_lon, marker|
      marker.lat lat_lon.lat
      marker.lng lat_lon.lon
      meter = lat_lon.parking_meter

      color = "18bc9c"
      if meter.is_broken
        color = "e74c3c"
      elsif meter.is_occupied
        color = "3498db"
      end
      marker.picture({
       :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=|" + color + "|000000", 
       :width   => 32,
       :height  => 32
       })
      marker.json({ :meter_id => meter.id, :meter_name => meter.name })
    end
  end


  # GET /lat_lons/1
  # GET /lat_lons/1.json
  def show
  end

  # GET /lat_lons/new
  def new
    @lat_lon = LatLon.new
  end

  # GET /lat_lons/1/edit
  def edit
  end

  # POST /lat_lons
  # POST /lat_lons.json
  def create
    @lat_lon = LatLon.new(lat_lon_params)

    respond_to do |format|
      if @lat_lon.save
        format.html { redirect_to @lat_lon, notice: 'Lat lon was successfully created.' }
        format.json { render :show, status: :created, location: @lat_lon }
      else
        format.html { render :new }
        format.json { render json: @lat_lon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lat_lons/1
  # PATCH/PUT /lat_lons/1.json
  def update
    respond_to do |format|
      if @lat_lon.update(lat_lon_params)
        format.html { redirect_to @lat_lon, notice: 'Lat lon was successfully updated.' }
        format.json { render :show, status: :ok, location: @lat_lon }
      else
        format.html { render :edit }
        format.json { render json: @lat_lon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lat_lons/1
  # DELETE /lat_lons/1.json
  def destroy
    @lat_lon.destroy
    respond_to do |format|
      format.html { redirect_to lat_lons_url, notice: 'Lat lon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lat_lon
      @lat_lon = LatLon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lat_lon_params
      params.require(:lat_lon).permit(:lat, :lon, :parking_meter_id)
    end
  end


