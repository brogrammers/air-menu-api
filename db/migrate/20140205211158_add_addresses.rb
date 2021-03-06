class AddAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :county
      t.string :state
      t.string :country
      t.references :contactable, polymorphic: true

      t.timestamps
    end
  end
end
