class AddEnumToOrderAndOrderItem < ActiveRecord::Migration
  def change
    add_column :orders, :state_cd, :integer
    add_column :orders, :approved_time, :timestamp
    add_column :orders, :served_time, :timestamp
    add_column :orders, :cancelled_time, :timestamp
    remove_column :orders, :end_prepared
    remove_column :orders, :end_served
    remove_column :orders, :start
    remove_column :orders, :served
    remove_column :orders, :prepared

    add_column :order_items, :state_cd, :integer
    add_column :order_items, :approved_time, :timestamp
    add_column :order_items, :declined_time, :timestamp
    add_column :order_items, :start_prepare_time, :timestamp
    add_column :order_items, :end_prepare_time, :timestamp
    add_column :order_items, :served_time, :timestamp
    remove_column :order_items, :served
  end
end
