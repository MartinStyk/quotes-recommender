class AddAttributesOfQuote < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :length, :integer, default: 0
  end
end
