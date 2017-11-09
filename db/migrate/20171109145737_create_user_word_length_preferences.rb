class CreateUserWordLengthPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_word_length_preferences do |t|
      t.references :user, foreign_key: true
      t.integer :length
      t.float :preference

      t.timestamps
    end
  end
end
