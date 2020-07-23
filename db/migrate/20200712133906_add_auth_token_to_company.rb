class AddAuthTokenToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :auth_token, :string
  end
end
