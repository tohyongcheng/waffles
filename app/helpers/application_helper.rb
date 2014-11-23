module ApplicationHelper
	def current_customer
		Customer.find_by_id(session[:customer_id])
	end

  def current_order
    if current_customer.present?
      current_customer.orders.where(status: 0).first_or_create
    end
  end

	def login(customer)
		session[:customer_id] = customer.id
	end

  def logout
    session[:customer_id] = nil
  end

  def short_time(string)
    Time.at(string).to_formatted_s(:short)
  end
end
