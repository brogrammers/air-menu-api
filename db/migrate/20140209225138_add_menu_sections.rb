class AddMenuSections < ActiveRecord::Migration
  def change
    create_table :menu_sections do |t|
      t.string :name
      t.string :description
      t.belongs_to :menu
      t.belongs_to :staff_kind

      t.timestamps
    end
  end
end
