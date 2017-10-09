class CreateJoinTableCategoryQuote < ActiveRecord::Migration[5.1]
  def change
    create_join_table :categories, :quotes do |t|
      t.index [:category_id, :quote_id]
      t.index [:quote_id, :category_id]
    end
  end
end
