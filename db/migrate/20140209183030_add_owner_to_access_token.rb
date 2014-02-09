class AddOwnerToAccessToken < ActiveRecord::Migration
  def change
    add_column :oauth_access_tokens, :owner_id, :integer, :null => true
    add_column :oauth_access_tokens, :owner_type, :string, :null => true
  end
end
