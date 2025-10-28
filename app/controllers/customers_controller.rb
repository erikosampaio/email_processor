class CustomersController < ApplicationController
  def index
    @customers = Customer.order(created_at: :desc)
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
