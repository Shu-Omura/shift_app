class AddDeterminedToCollectedShift < ActiveRecord::Migration[6.0]
  def change
    add_column :collected_shifts, :is_determined, :boolean, default: false
  end
end
