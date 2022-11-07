class ShoeModel < ApplicationRecord
  validates :name, uniqueness: true
end
