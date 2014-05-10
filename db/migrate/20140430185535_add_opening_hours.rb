class AddOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.string :day
      t.time :start
      t.time :end
      t.belongs_to :restaurant

      t.timestamps
    end
  end
end
