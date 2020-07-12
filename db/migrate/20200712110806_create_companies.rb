class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :address
      t.integer :tel

      t.timestamps
    end
  end
end
