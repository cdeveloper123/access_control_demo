class CreateParticipationAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :participation_areas do |t|
      t.string :title
      t.text :content
      t.integer :min_age
      t.integer :max_age
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
