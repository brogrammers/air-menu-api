class AddMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.belongs_to :restaurant

      t.timestamps
    end
  end
end
