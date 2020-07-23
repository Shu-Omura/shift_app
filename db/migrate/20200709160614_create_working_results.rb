class CreateWorkingResults < ActiveRecord::Migration[6.0]
  def change
    create_table :working_results do |t|
      t.references :user, null: false, foreign_key: true
      t.string :term
      t.integer :total_time
      t.integer :total_wage

      t.timestamps
    end
  end
end
