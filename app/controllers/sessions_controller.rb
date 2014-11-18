class SessionsController < ApplicationController
	include ApplicationHelper
	def create
		@customer = Customer.authenticate params[:customer]
		if @customer.nil?
			redirect_to root_path
		else
			login(@customer)
			redirect_to root_path
		end
	end

	def new
		@customer = Customer.new
	end

	def destroy
		logout
		redirect_to root_path
	end

	private

end