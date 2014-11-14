class BooksController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin", except: [:index, :show]

  before_filter :load_book, except: [:index, :new, :create]

  def new
    @book = Book.new
  end

  def create
    @book = Book.create book_params
    render :show
  end

  def index
    @books = Book.all
  end

  def show
  end

  def edit
  end

  def update
    @book.update_attributes book_params
    render :show
  end

  private

  def load_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :price, :isbn10, :isbn13, :copies)
  end
end
