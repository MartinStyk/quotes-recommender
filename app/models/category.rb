class Category < ApplicationRecord
  has_many :quote_categories
  has_many :quotes, through: :quote_categories
  has_many :user_category_preferences
  has_many :users, through: :user_category_preferences

  validates :name,
            presence: { message: 'cannot be empty.' },
            uniqueness: true

end
