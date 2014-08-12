class AddParentEmailsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :email, :string
    add_column :students, :parent_1_email, :string
    add_column :students, :parent_2_email, :string
  end
end
