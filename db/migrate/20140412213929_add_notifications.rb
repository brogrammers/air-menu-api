class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :content
      t.boolean :read
      t.integer :remindable_id
      t.integer :remindable_type
      t.string :payload

      t.timestamps
    end
  end
end
