class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false

      t.timestamps
    end
  end
end
