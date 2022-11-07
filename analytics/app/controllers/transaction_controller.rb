class TransactionController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: {status: :ok}, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end


  private

    def transaction_params
      params.require(:transaction).permit(:store, :model, :inventory)
    end
end
