class ChangeDescriptionForRestaurants < ActiveRecord::Migration
  def change
    change_column :restaurants, :description, :text
  end
end
