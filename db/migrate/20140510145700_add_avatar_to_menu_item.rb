class AddAvatarToMenuItem < ActiveRecord::Migration
  def change
    add_column :menu_items, :avatar, :string
  end
end
