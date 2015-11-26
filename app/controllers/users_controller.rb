class UsersController < ApplicationController
  before_action :require_user, only: [:index, :show]
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      @user.parked_meter = ParkedMeter.new
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  # PATCH /add_recent/1.json
  def add_recent
    @user = User.find(session[:user_id])
    if @user.parking_meters.where(:id => params[:meter_id]).exists?
      recent = @user.recent_meters.where(:parking_meter_id => params[:meter_id]).first
      recent.touch
      respond_to do |format|
        format.json { render json: @user.as_json(:only => [:id]), status: :ok, location: @user }
      end
    else
      meter = ParkingMeter.find(params[:meter_id])
      @user.parking_meters << meter
      respond_to do |format|
        if @user.save
          format.json { render json: @user.as_json(:only => [:id]), status: :ok, location: @user }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :parked_meter)
  end
end

