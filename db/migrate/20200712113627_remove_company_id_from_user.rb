class RemoveCompanyIdFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :company_id, :integer
  end
end
