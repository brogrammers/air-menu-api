class AddOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :restaurant
      t.boolean :prepared
      t.boolean :served
      t.timestamp :start
      t.timestamp :end_prepared
      t.timestamp :end_served
    end
  end
end
