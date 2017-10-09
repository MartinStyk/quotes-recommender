class Category < ApplicationRecord
  has_and_belongs_to_many :quotes

  validates :name,
            presence: { message: 'cannot be empty.' },
            uniqueness: true
  
end
