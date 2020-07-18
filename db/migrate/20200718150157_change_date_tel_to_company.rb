class ChangeDateTelToCompany < ActiveRecord::Migration[6.0]
  def up
    change_column :companies, :tel, :string
  end

  def down
    change_column :companies, :tel, :integer, using: 'tel::integer'
  end
end
