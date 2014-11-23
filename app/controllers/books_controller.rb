class BooksController < ApplicationController
  include BooksHelper
  include ApplicationHelper
  before_filter :load_book, except: [:index, :new, :create, :add_to_order]

  def index
    @books = Book.all

    if current_customer.present?
      set_of_books_i_bought = Set.new
      books_bought = current_order.line_items.each do |li|
        set_of_books_i_bought.add(li.book_id)
      end
      set_of_books_to_recommend = Set.new
      set_of_books_i_bought.each do |book_id|
        order_ids = LineItem.where(book_id: book_id).map { |l| l.order_id }
        order_ids.each do |id|
          o = Order.find(id)
          o.line_items.each do |line_item|
            set_of_books_to_recommend.add(line_item.book_id)
          end
        end
      end

      recommendations_id = set_of_books_to_recommend - set_of_books_i_bought

      @recommendations = Book.where(id: recommendations_id.to_a)
      print @recommendations
    else
      @recommendations = []
    end

    
  end

  def show
    @line_item = LineItem.new
    @opinion = Opinion.new
  end

  def add_to_order
    current_order.add_book(book_id: params[:book_id], quantity: line_item_params[:quantity])
    # LineItem.create(order_id: current_order.id, quantity: line_item_params[:quantity], book_id: params[:book_id])
    redirect_to cart_orders_path
  end

  private
  def line_item_params
    params.require(:line_item).permit(:customer_id, :quantity)
  end

  def load_book
    @book = Book.find(params[:id])
  end

end
