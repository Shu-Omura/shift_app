class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @shifts = CollectedShift.where(user: current_user)
  end

  def index
    @users = User.colleagues(current_user)
  end

  private

  def correct_user
    user = User.find(params[:id])
    redirect_to users_path unless user == current_user
  end
end
