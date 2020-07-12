class AddInitialCompany < ActiveRecord::Migration[6.0]
  class Company < ActiveRecord::Base
  end
  def up
    Company.create(name: "未分類")
  end

  def down
    Company.delete_all
  end
end
