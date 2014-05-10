class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :identities, :avatar, :string
  end
end
