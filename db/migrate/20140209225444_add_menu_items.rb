class AddMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :currency
      t.belongs_to :menu_section

      t.timestamps
    end
  end
end
