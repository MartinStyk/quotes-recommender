class CreateUserCategoryPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_category_preferences do |t|
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.float :preference

      t.timestamps
    end
  end
end
