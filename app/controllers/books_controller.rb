class BooksController < ApplicationController
  include BooksHelper
  include ApplicationHelper
  require 'ostruct'
  before_filter :load_book, except: [:index, :new, :create, :add_to_order, :search, :search_page]

  def index
    @books = Book.all
    if current_customer.present?
      set_of_books_i_bought = Set.new
      current_customer.orders.each do |o|
        o.line_items.each do |li|
          set_of_books_i_bought.add(li.book_id)
        end
      end


      book_tuple = "(" + set_of_books_i_bought.to_a.join(",") + ")"
      if book_tuple == "()"
        @recommendations = []
        return
      end
      @recommendations = ActiveRecord::Base.connection.execute("

        SELECT books.*, SUM(quantity) AS count
        FROM line_items
        JOIN books ON book_id = books.id
        JOIN orders ON order_id = orders.id
        WHERE customer_id IN
          (SELECT customer_id
          FROM line_items JOIN orders ON order_id = orders.id
          WHERE book_id IN #{book_tuple}
          AND customer_id <> #{current_customer.id})
        AND book_id NOT IN #{book_tuple}
        GROUP BY books.id
        ORDER BY count DESC

        ")
    else
      @recommendations = []
    end


  end

  def show
    @line_item = LineItem.new
    @opinion = Opinion.new
    @useful_opinions = @book.useful_opinions(params[:opinions].try(:[],:limit))
  end

  def add_to_order
    if line_item_params[:quantity].to_i <= Book.find(params[:book_id]).copies.to_i
      current_order.add_book(book_id: params[:book_id], quantity: line_item_params[:quantity])
      redirect_to cart_orders_path
    else
      flash[:error] = "You have exceeded the number of avaliable copies."
      redirect_to :back
    end
    # LineItem.create(order_id: current_order.id, quantity: line_item_params[:quantity], book_id: params[:book_id])
  end

  def search
=begin
    Users may search for books, by asking conjunctive
queries on the authors, and/or publisher, and/or title, and/or subject. Your system should allow the user to specify that the results are to be sorted a) by year, or b) by the average score of the feedbacks.
=end
    @books = Book.search(params[:search])
  end

  def search_page
  end

  private
  def line_item_params
    params.require(:line_item).permit(:customer_id, :quantity)
  end

  def load_book
    @book = Book.find(params[:id])
  end

end
