class AddAvatarToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :avatar, :string
  end
end
