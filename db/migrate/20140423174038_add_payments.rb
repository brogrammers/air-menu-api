class AddPayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.integer :credit_card_id

      t.timestamps
    end
  end
end
