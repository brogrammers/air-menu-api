class AddCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :website

      t.timestamps
    end
  end
end
