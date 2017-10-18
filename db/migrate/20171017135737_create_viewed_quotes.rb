class CreateViewedQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :viewed_quotes, id: false do |t|
      t.references :quote, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
