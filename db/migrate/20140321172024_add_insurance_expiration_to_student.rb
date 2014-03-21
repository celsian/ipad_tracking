class AddInsuranceExpirationToStudent < ActiveRecord::Migration
  def change
    add_column :students, :insurance_expiration, :string
  end
end
