class DropTableCategoriesQuotes < ActiveRecord::Migration[5.1]
  def change
    drop_table :categories_quotes
  end
end
