class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order
  scope :from_this_month, -> { where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month) }

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end

  def total
    book.price * quantity
  end
end
