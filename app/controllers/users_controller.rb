class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @collected_shift = current_user.collected_shifts.build
    @collected_shifts = CollectedShift.where(user: current_user)
    @attendances = Attendance.where(user: current_user)
  end

  def index
    @users = User.colleagues(current_user)
  end

  private

  def correct_user
    user = User.find(params[:id])
    redirect_to users_path unless current_user.admin? || (user == current_user)
  end
end
