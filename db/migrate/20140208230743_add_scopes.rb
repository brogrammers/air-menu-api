class AddScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name

      t.timestamps
    end
  end
end