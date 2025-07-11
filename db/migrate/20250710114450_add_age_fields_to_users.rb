class AddAgeFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :consent_granted, :boolean, default: false
  end
end
