class CollectedShiftsController < ApplicationController
  def index
    @users = User.where(company_id: current_user.company_id)
    @collected_user_shifts = CollectedShift.where(user: current_user)
  end

  def show
    @collected_shift = CollectedShift.find(params[:id])
  end

  def new
  end

  def edit
  end
end
