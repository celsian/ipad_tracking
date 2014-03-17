class CreateFinances < ActiveRecord::Migration
  def change
    create_table :finances do |t|
      t.boolean :charge
      t.decimal :amount
      t.string :note
      t.references :student, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
