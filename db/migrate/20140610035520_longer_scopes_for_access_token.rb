class LongerScopesForAccessToken < ActiveRecord::Migration
  def change
    change_column :oauth_access_tokens, :scopes, :text
  end
end
