class CreateTableQuoteCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :quote_categories do |t|
      t.references :quote, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
    end
  end
end
