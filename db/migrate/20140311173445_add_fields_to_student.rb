class AddFieldsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :insurance, :string
    add_column :students, :current_school, :string
    add_column :students, :parent_1_name, :string
    add_column :students, :parent_1_phone, :string
    add_column :students, :parent_2_name, :string
    add_column :students, :parent_2_phone, :string
  end
end
