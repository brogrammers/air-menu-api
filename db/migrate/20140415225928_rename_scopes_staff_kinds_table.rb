class RenameScopesStaffKindsTable < ActiveRecord::Migration
  def change
    drop_table :scopes_staff_kinds
    create_table :staff_kind_scopes do |t|
      t.references :staff_kind
      t.references :scope
    end
  end
end
