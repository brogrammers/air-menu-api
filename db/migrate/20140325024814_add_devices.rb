class AddDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :uuid
      t.string :token
      t.string :platform
      t.integer :notifiable_id
      t.string :notifiable_type

      t.timestamps
    end
  end
end
