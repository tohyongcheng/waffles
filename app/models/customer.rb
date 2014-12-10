class Customer < ActiveRecord::Base
  has_many :orders
  has_many :opinions
  has_many :opinion_ratings

  validates_presence_of :username 
  validates_presence_of :full_name 
  validates_presence_of :password

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

  def confirmed_orders
    results = Order.connection.execute"SELECT orders.* FROM orders 
      JOIN customers on orders.customer_id = customers.id
      WHERE customer_id = #{id}
      AND orders.status = 1
    "
    Order.raw_to_orders(results)
  end

  def all_opinions
    results = Opinion.connection.execute"SELECT opinions.* FROM opinions 
      JOIN customers on opinions.customer_id = customers.id
      WHERE customer_id = #{id}
    "
    Opinion.raw_to_opinions(results)
  end

  def feedback
    results = OpinionRating.connection.execute "
      SELECT opinion_ratings.* FROM opinions
      JOIN opinion_ratings ON opinion_ratings.opinion_id = opinions.id
      WHERE opinion_ratings.customer_id = #{id}
      ORDER BY opinion_ratings.rating DESC
    "
    OpinionRating.raw_to_opinion_ratings(results)
  end
end
