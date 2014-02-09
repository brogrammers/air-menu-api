class AddStaffKindsScopes < ActiveRecord::Migration
  def change
    create_table :scopes_staff_kinds do |t|
      t.belongs_to :staff_kind
      t.belongs_to :scope
    end
  end
end
