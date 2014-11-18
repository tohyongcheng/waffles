module ApplicationHelper
	def current_user
		Customer.find_by_id(session[:customer_id])
	end

	def login(customer)
		session[:customer_id] = customer.id
	end

  def logout
    session[:customer_id] = nil
  end
end
