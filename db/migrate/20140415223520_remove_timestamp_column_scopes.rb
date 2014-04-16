class RemoveTimestampColumnScopes < ActiveRecord::Migration
  def change
    remove_column :scopes_staff_kinds, :created_at
    remove_column :scopes_staff_kinds, :updated_at
  end
end
