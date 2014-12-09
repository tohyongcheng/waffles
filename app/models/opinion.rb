class Opinion < ActiveRecord::Base
  belongs_to :book
  belongs_to :customer
  has_many :opinion_ratings

  validate :only_one_opinion, on: :create
  before_save :default_value

  include ResultsHelper

  def self.raw_to_opinions(results)
    ResultsHelper.raw_to_model(results, self.name)
  end

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

  private

  def only_one_opinion
    book_ids = customer.opinions.map {|o| o.book.id }
    if book_ids.include? book_id
      errors.add(:book_id, "can have only one opinion")
    end
  end
  
  def default_value
    score ||= 0
  end

end
