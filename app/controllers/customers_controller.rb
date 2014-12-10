class CustomersController < ApplicationController

	def new
		@customer = Customer.new
	end

	def show
		@customer = current_customer

	end

	def create
		if params[:customer][:password] == params[:customer][:password_confirmation]
			@customer = Customer.create(user_params)
      if @customer.save
			  login @customer
      else
        flash[:error] = @customer.errors.full_messages.to_sentence
        redirect_to new_customer_path
        return
      end
		else
			flash[:error] = "passwords dont match."
      redirect_to new_customer_path
      return
		end
		redirect_to root_path
	end

	private
	def user_params
		params.require(:customer).permit(:full_name, :username, :password, :credit_card, :address, :phone)
	end
end
