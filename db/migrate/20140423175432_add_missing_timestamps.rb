class AddMissingTimestamps < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.timestamps
    end
    change_table :credit_cards do |t|
      t.timestamps
    end
  end
end
