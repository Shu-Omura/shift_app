class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.colleagues(current_user)
    @all_terms = Attendance.all_terms
    @term = params[:term] || Time.current.strftime('%Y/%m')
    @user_attendances = User.find_by(id: params[:id])&.attendances_on_term(@term)
  end

  def create
    @attendance = current_user.attendances.build(attendance_params)
    if @attendance.save
      redirect_to current_user, flash: { success: '勤怠を確定しました' }
    else
      redirect_to current_user, flash: { danger: @attendance.errors.full_messages.join(' / ') }
    end
  end

  def edit
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update(attendance_params)
      redirect_to current_user, flash: { success: '勤怠を変更しました' }
    else
      render 'edit'
    end
  end

  def destroy
    Attendance.find(params[:id]).destroy
    redirect_to current_user, flash: { success: '勤怠を削除しました' }
  end

  private

  def attendance_params
    params.require(:attendance).permit(:started_at, :finished_at)
  end

  def correct_user
    return true if current_user.admin?
    unless Attendance.find(params[:id]).user == current_user
      redirect_to current_user
    end
  end
end
