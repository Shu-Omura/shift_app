class CreatedShiftsController < ApplicationController
  def index
    users = User.colleagues(current_user)
    determined_shifts = CollectedShift.where(user: users).where(is_determined: true)
    @created_shifts = CreatedShift.where(collected_shift: determined_shifts)
  end

  def create
    collected_shift = CollectedShift.find(params[:collected_shift_id])
    collected_shift.update(is_determined: true)
    @created_shift = collected_shift.build_created_shift(started_at: collected_shift.started_at,
                                                         finished_at: collected_shift.finished_at)
    if @created_shift.save
      flash[:success] = "シフトを確定させました"
      redirect_to collected_shifts_path
    end
  end

  def destroy
    created_shift = CreatedShift.find(params[:id])
    created_shift.destroy
    created_shift.collected_shift.update(is_determined: false)
    flash[:success] = "シフトを未確定に変更しました"
    redirect_to created_shifts_path
  end
end
