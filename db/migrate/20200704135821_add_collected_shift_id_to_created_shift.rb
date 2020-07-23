class AddCollectedShiftIdToCreatedShift < ActiveRecord::Migration[6.0]
  def up
    add_reference :created_shifts, :collected_shift, index: true
  end

  def down
    remove_reference :created_shifts, :collected_shift, index: true
  end
end
