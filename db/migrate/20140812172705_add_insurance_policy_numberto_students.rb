class AddInsurancePolicyNumbertoStudents < ActiveRecord::Migration
  def change
        add_column :students, :policy_number, :string
        remove_column :students, :insurance, :string
  end
end
