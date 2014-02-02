class AddIdentities < ActiveRecord::Migration
  def change
  	create_table :identities do |t|
  		t.string :username
  		t.string :password
  		t.string :salt
  		t.string :email
  		t.references :identifiable, polymorphic: true

  		t.timestamps
  	end
  end
end
