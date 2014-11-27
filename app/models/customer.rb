class Customer < ActiveRecord::Base
  has_many :orders
  has_many :opinions
  has_many :opinion_ratings

	def self.authenticate(params)
		c = Customer.find_by_username(params[:username])
		if c.nil? or c.password != params[:password]
			return
		else
			return c
		end
	end

  def has_given_opinion(book_id)
    not Customer.
      joins(:opinions).
      where("opinions.book_id" => book_id).
      empty?
  end
end
