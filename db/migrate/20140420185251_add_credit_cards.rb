class AddCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :number
      t.string :type
      t.string :month
      t.string :cvc
      t.belongs_to :user
    end
  end
end
