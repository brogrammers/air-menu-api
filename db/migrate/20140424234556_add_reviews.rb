class AddReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :subject
      t.string :message
      t.integer :rating
      t.integer :user_id
      t.integer :menu_item_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
