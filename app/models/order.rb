class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :customer
  include ResultsHelper

  def self.raw_to_orders(results)
    ResultsHelper.raw_to_model(results, self.name)
  end

  def total
    line_items.each.sum(&:total)
  end

  def add_book(params)
    l = self.line_items.where(book_id: params[:book_id]).first
    if l.nil?
      l = LineItem.create(order_id: self.id, book_id: params[:book_id], quantity: params[:quantity])
    else
      new_quantity = l.quantity + params[:quantity].to_i
      l.update_attributes(quantity: new_quantity)
    end

    # self.line_items
    # current_order.add_book(book_id: params[:book_id], quantity: line_item_params[:quantity])
  end

  def update_copies
    self.line_items.each do |li|
      book = Book.find(li.book_id)
      book.update_attributes(copies: book.copies-li.quantity)
    end
  end

end
