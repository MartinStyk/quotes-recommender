class AddAvgWordLengthAttributesOfQuote < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :word_avg_length, :integer, default: 0
  end
end
