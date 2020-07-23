class AddWorkingResultRefToAttendance < ActiveRecord::Migration[6.0]
  def change
    add_reference :attendances, :working_result, null: false, foreign_key: true
  end
end
