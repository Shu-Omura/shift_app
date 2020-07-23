class CollectedShiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_company, only: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :check_is_determined, only:[:edit, :update]

  def index
    @users = User.colleagues(current_user)
    @collected_shifts = CollectedShift.where(user: @users)
    @created_shift = CreatedShift.new
  end

  def create
    @collected_shift = current_user.collected_shifts.build(shift_params)
    if @collected_shift.save
      redirect_to current_user, flash: {success: 'シフトを提出しました'}
    else
      @user = current_user
      @collected_shifts = CollectedShift.where(user: current_user)
      @attendances = Attendance.where(user: current_user).recent.page(params[:page]).per(PER)
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
    user = CollectedShift.find(params[:id]).user
    redirect_to unless user == current_user
  end

  def check_is_determined
    if CollectedShift.find(params[:id]).is_determined
      redirect_to current_user, flash: {danger: '確定済みのシフトの変更はできません'}
    end
  end
end
