class AddTableNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :table_number, :string
  end
end
