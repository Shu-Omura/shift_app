class AddCompanyRefToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :company, foreign_key: true
  end
end
