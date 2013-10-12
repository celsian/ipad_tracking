class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_type
      t.string :serial_number
      t.string :district_tag
      t.references :student, index: true

      t.timestamps
    end
  end
end
