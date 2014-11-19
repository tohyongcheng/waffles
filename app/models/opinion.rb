class Opinion < ActiveRecord::Base
  belongs_to :book
  belongs_to :customer
  has_many :opinion_ratings


  def vote_sum
    if opinion_ratings.empty?
      return 0
    else
      opinion_ratings.map{|o|o.rating}.inject(:+)
    end
  end

  def usefulness
    count = opinion_ratings.count
    if count.zero?
      return 0
    else
      vote_sum.to_f/opinion_ratings.count
    end
  end

  def customer_ids_who_rated
    opinion_ratings.map {|r| r.customer.id}
  end

  def has_customer_rated?(customer)
    customer_ids_who_rated.include?(customer.id)
  end
end
