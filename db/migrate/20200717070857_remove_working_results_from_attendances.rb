class RemoveWorkingResultsFromAttendances < ActiveRecord::Migration[6.0]
  def up
    remove_reference :attendances, :working_result, null: false, foreign_key: true
  end

  def down
    add_reference :attendances, :working_result, null: false, foreign_key: true
  end
end
