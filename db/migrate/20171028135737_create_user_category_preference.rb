class CreateUserCategoryPreference < ActiveRecord::Migration[5.1]
  def change
    create_table :user_category_preference, id: false do |t|
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :preference

      t.timestamps
    end
  end
end
