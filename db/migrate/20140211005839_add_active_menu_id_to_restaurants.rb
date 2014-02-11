class AddActiveMenuIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :active_menu_id, :integer
  end
end
