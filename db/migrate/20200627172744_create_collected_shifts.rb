class CreateCollectedShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :collected_shifts do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
  end
end
