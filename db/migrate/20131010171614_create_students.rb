class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :id_number
      t.integer :grade_level
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
