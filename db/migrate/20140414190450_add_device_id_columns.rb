class AddDeviceIdColumns < ActiveRecord::Migration
  def change
    add_column :groups, :device_id, :integer
    add_column :staff_members, :device_id, :integer
  end
end
