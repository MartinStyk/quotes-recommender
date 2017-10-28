class Category < ApplicationRecord
  has_and_belongs_to_many :quotes
  has_many :user_category_preferences
  has_many :users, through: :user_category_preferences

  validates :name,
            presence: { message: 'cannot be empty.' },
            uniqueness: true

end
