class AddHomePhonetoStudents < ActiveRecord::Migration
  def change
    add_column :students, :home_phone, :string
  end
end
