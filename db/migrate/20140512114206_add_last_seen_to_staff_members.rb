class AddLastSeenToStaffMembers < ActiveRecord::Migration
  def change
    add_column :staff_members, :last_seen, :timestamp
  end
end
