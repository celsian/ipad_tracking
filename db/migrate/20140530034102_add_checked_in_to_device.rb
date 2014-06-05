class AddCheckedInToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :checked_in, :boolean
  end
end
