class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end

  def total
    book.price * quantity
  end
end
