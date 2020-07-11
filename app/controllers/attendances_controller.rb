class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: [:index]

  def new
    @attendance = current_user.attendances.build
  end

  def create
    @attendance = current_user.attendances.build(attendance_params)
    if @attendance.save
      flash[:success] = "勤怠を確定しました"
      redirect_to current_user
    else
      render "new"
    end
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update(attendance_params)
      flash[:success] = "勤怠を変更しました"
      redirect_to current_user
    else
      render "edit"
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    flash[:success] = "勤怠を削除しました"
    redirect_to current_user
  end

  def search
  end

  private

  def attendance_params
    params.require(:attendance).permit(:started_at, :finished_at)
  end
end
