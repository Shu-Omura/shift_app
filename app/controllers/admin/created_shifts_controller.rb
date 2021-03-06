module Admin
  class CreatedShiftsController < ApplicationController
    before_action :admin_user

    def index
      user_ids = User.select(:id).colleagues(current_user)
      @created_shifts = CreatedShift.user_created_shifts(user_ids)
    end

    def create
      collected_shift = CollectedShift.find(params[:collected_shift_id])
      @created_shift = collected_shift.build_created_shift(started_at: collected_shift.started_at,
                                                           finished_at: collected_shift.finished_at)
      if @created_shift.save
        redirect_to collected_shifts_path, flash: { success: 'シフトを確定させました' }
      else
        @users = User.colleagues(current_user)
        @collected_shifts = CollectedShift.where(user: @users)
        render 'collected_shifts/index'
      end
    end

    def destroy
      CreatedShift.find(params[:id]).destroy
      redirect_to created_shifts_path, flash: { success: 'シフトを未確定に変更しました' }
    end
  end
end
