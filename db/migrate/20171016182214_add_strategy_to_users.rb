class AddStrategyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :strategy, :integer, default: 0
  end
end
