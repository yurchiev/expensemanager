class Expense < ApplicationRecord
  validates :name, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
  validates :description, presence: true
end
