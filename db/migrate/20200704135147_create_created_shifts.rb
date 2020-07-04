class CreateCreatedShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :created_shifts do |t|
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
  end
end
