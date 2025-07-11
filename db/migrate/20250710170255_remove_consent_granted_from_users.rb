class RemoveConsentGrantedFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :consent_granted, :boolean
  end
end
