class AddBaseSalaryToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :base_salary, :integer, default: 1000
  end
end
