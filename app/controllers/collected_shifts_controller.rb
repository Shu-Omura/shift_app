class CollectedShiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.colleagues(current_user)
    @collected_shifts = CollectedShift.where(user: @users)
  end

  def create
    @collected_shift = current_user.collected_shifts.build(shift_params)
    if @collected_shift.save
      redirect_to current_user, flash: {success: 'シフトを提出しました'}
    else
      @user = current_user
      @collected_shifts = CollectedShift.where(user: current_user)
      render 'users/show'
    end
  end

  def edit
    @collected_shift = CollectedShift.find(params[:id])
  end

  def update
    @collected_shift = CollectedShift.find(params[:id])
    if @collected_shift.update(shift_params)
      redirect_to current_user, flash: {success: 'シフトを更新しました'}
    else
      render 'edit'
    end
  end

  def destroy
    CollectedShift.find(params[:id]).destroy
    redirect_to current_user, flash: {success: 'シフトを削除しました'}
  end

  private

  def shift_params
    params.require(:collected_shift).permit(:started_at, :finished_at)
  end

  def correct_user
    shift = CollectedShift.find(params[:id])
    redirect_to root_url unless current_user.collected_shifts.include?(shift)
  end
end
