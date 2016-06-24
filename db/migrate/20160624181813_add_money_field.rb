class AddMoneyField < ActiveRecord::Migration
  def change
    add_column :borrowers, :needed, :integer
  end
end
