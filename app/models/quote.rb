class Quote < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :ratings
  has_many :users, through: :ratings
end
