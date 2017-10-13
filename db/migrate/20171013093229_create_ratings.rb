class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :quote, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :user_rating
      t.integer :suggested_rating
      t.timestamps
    end
  end
end
