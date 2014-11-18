class CustomersController < ApplicationController
	def new
		@customer = Customer.new
	end

	def create
		@customer = Customer.create(user_params)
		redirect_to root_path
	end

	private
	def user_params
		params.require(:customer).permit(:full_name, :username, :password, :credit_card, :address, :phone)
	end
end