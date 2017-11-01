class Quote < ApplicationRecord
  has_many :quote_categories
  has_many :categories, through: :quote_categories
  has_many :ratings
  has_many :users, through: :ratings
  has_many :viewed_quotes
  has_many :users, through: :viewed_quotes
end
