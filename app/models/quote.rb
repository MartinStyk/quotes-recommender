class Quote < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :ratings
  has_many :users, through: :ratings
  has_many :viewed_quotes
  has_many :users, through: :viewed_quotes
end
