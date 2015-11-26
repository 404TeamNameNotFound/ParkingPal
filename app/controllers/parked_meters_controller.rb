class ParkedMetersController < ApplicationController
  before_action :load_parent, :set_parked_meter, only: [:show, :edit, :update, :destroy]

  # GET /parked_meters
  # GET /parked_meters.json
  def index
    @user = User.find(params[:user_id])
    @parked_meter = @user.parked_meter
  end

  # GET /parked_meters/1
  # GET /parked_meters/1.json
  def show
  end

  # GET /parked_meters/new
  def new
    @parked_meter = ParkedMeter.new
  end

  # GET /parked_meters/1/edit
  def edit
  end

  # POST /parked_meters
  # POST /parked_meters.json
  def create
    @parked_meter = ParkedMeter.new(parked_meter_params)

    respond_to do |format|
      if @parked_meter.save
        format.html { redirect_to @parked_meter, notice: 'Parked meter was successfully created.' }
        format.json { render :show, status: :created, location: @parked_meter }
      else
        format.html { render :new }
        format.json { render json: @parked_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parked_meters/1
  # PATCH/PUT /parked_meters/1.json
  def update
    # convert from milliseconds from epoch to Ruby time object
    params[:parked_meter][:time_left] = Time.at(Integer(params[:parked_meter][:time_left]) / 1000.0)
    respond_to do |format|
      if @parked_meter.update(parked_meter_params)
        format.html { redirect_to @parked_meter, notice: 'Parked meter was successfully updated.' }
        format.json { render :show, status: :ok, location: @parked_meter }
      else
        format.html { render :edit }
        format.json { render json: @parked_meter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parked_meters/1
  # DELETE /parked_meters/1.json
  def destroy
    @parked_meter.destroy
    respond_to do |format|
      format.html { redirect_to parked_meters_url, notice: 'Parked meter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parked_meter
      @parked_meter = @user.parked_meter
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parked_meter_params
      puts '=============================='
      puts params[:parked_meter][:time_left]
      params.require(:parked_meter).permit(:time_left, :parking_meter_id)
      
    end

    def load_parent
      @user = User.find(params[:user_id])
    end
end
