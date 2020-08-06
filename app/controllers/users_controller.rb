class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]
  before_action :check_company, only: [:index]

  def show
    @user = User.find(params[:id])
    @collected_shift = current_user.collected_shifts.build
    @collected_shifts = CollectedShift.where(user: current_user)
    @attendance = current_user.attendances.build
    @attendances = Attendance.where(user: current_user).in_this_month.recent
  end

  def index
    @users = User.colleagues(current_user)
  end

  private

  def correct_user
    unless User.find(params[:id]) == current_user
      redirect_to users_path
    end
  end
end
