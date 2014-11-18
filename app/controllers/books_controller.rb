class BooksController < ApplicationController
  before_filter :load_book, except: [:index, :new, :create, :add_to_order]

  def index
    @books = Book.all
  end

  def show
    @line_item = LineItem.new
  end

  def add_to_order
    current_order.add_book(book_id: params[:book_id], quantity: line_item_params[:quantity])
    # LineItem.create(order_id: current_order.id, quantity: line_item_params[:quantity], book_id: params[:book_id])
    redirect_to book_path(params[:book_id])
  end

  private
  def line_item_params
    params.require(:line_item).permit(:customer_id, :quantity)
  end

  def load_book
    @book = Book.find(params[:id])
  end

end
