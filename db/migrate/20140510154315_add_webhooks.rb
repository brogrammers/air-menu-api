class AddWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :host
      t.string :path
      t.text :params
      t.text :headers
      t.integer :restaurant_id
      t.string :on_action
      t.string :on_method

      t.timestamps
    end
  end
end
