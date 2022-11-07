class Store < ApplicationRecord
  validates :name, uniqueness: true
end
