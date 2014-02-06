class AddStaffMember < ActiveRecord::Migration
  def change
    create_table :staff_members do |t|
      t.string :name
      t.integer :staff_kind_id
      t.integer :group_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
