class Transaction < ApplicationRecord

  after_create :create_store, :create_shoe_model

  private

    def create_store
      Store.find_or_create_by name: self.store
    end

    def create_shoe_model
      ShoeModel.find_or_create_by name: self.model
    end
end
