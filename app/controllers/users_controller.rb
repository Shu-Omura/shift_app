class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @collected_user_shifts = CollectedShift.where(user: current_user)
  end

  def index
    @users = User.where(company_id: current_user.company_id)
  end
end
