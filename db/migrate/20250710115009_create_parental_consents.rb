class CreateParentalConsents < ActiveRecord::Migration[8.0]
  def change
    create_table :parental_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :parent_email
      t.string :consent_token
      t.datetime :consent_given_at

      t.timestamps
    end
  end
end
