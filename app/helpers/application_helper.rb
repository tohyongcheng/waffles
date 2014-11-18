module ApplicationHelper
	def current_customer
		Customer.find_by_id(session[:customer_id])
	end

  def current_order
    if current_customer.present?
      Order.find_or_create_by(:customer_id => current_customer.id) do |u|
        u.status = "incomplete"
      end
    end
  end

	def login(customer)
		session[:customer_id] = customer.id
	end

  def logout
    session[:customer_id] = nil
  end
end
