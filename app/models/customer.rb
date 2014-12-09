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
    result = ActiveRecord::Base.connection.execute("
      SELECT * FROM opinions
      WHERE opinions.book_id = #{book_id}
      AND opinions.customer_id = #{self.id}
    ")
    result.count != 0
  end
end
