class AddRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.boolean :loyalty
      t.boolean :remote_order
      t.float :conversion_rate
      t.integer :company_id

      t.timestamps
    end
  end
end
