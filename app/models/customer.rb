class Customer < ActiveRecord::Base
  has_one :order
	def self.authenticate(params)
		c = Customer.find_by_username(params[:username])
		if c.nil? or c.password != params[:password]
			return
		else
			return c
		end
	end
end