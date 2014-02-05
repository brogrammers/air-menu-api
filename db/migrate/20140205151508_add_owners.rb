class AddOwners < ActiveRecord::Migration
  def change
  	create_table :owners do |t|
      t.string :name
      t.integer :company_id

      t.timestamps
  	end
  end
end