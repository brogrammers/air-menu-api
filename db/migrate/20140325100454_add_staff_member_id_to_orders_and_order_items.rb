class AddStaffMemberIdToOrdersAndOrderItems < ActiveRecord::Migration
  def change
    add_column :orders, :staff_member_id, :integer
    add_column :order_items, :staff_member_id, :integer

    add_column :staff_kinds, :accept_orders, :boolean
    add_column :staff_kinds, :accept_order_items, :boolean
  end
end
