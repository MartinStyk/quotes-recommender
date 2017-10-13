class Rating < ApplicationRecord
  belongs_to :quote
  belongs_to :user

  def self.default_scope
    order(created_at: :desc)
  end
end