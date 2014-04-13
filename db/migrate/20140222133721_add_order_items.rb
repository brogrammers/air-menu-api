class AddOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :comment
      t.integer :count
      t.boolean :served
      t.belongs_to :order
      t.belongs_to :menu_item

      t.timestamps
    end
  end
end
