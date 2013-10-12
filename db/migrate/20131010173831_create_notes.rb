class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :note
      t.references :device, index: true

      t.timestamps
    end
  end
end
