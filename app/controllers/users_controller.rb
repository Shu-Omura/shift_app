class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @collected_shift = current_user.collected_shifts.build
    @collected_shifts = CollectedShift.where(user: current_user)
    @attendances = Attendance.where(user: current_user).recent
  end

  def index
    @users = User.colleagues(current_user)
  end

  private

  def correct_user
    user = User.find(params[:id])
    if current_user.admin?
      return true
    elsif user != current_user
      redirect_to users_path
    end
  end
end
