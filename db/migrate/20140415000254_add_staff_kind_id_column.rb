class AddStaffKindIdColumn < ActiveRecord::Migration
  def change
    add_column :menu_items, :staff_kind_id, :integer
  end
end
