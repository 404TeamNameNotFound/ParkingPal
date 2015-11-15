class LatLonsController < ApplicationController

  #before_action :require_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_lat_lon, only: [:show, :edit, :update, :destroy]

  # GET /lat_lons
  # GET /lat_lons.json
  def index
    @lat_lons = LatLon.all
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
