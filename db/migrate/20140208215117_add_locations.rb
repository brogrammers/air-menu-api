class AddLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.references :findable, polymorphic: true

      t.timestamps
    end
  end
end
