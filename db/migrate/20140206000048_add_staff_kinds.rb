class AddStaffKinds < ActiveRecord::Migration
  def change
    create_table :staff_kinds do |t|
      t.string :name
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
