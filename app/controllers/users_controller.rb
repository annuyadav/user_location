class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @hash = Gmaps4rails.build_markers(@user.nearbys(20)) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      marker.infowindow user.name
    end

    @hash << {
        lat: @user.latitude,
        lng: @user.longitude,
        infowindow: 'Your location',
        picture: {
            url: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
            width: 36,
            height: 36
        }
    }
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
  end

  private
  def set_user
    @user = User.where(params[:id]).first
  end

  def user_params
    params.require(:user).permit(:name, :address)
  end
end
