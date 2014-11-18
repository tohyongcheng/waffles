class BooksController < ApplicationController


  before_filter :load_book, except: [:index, :new, :create]

  def index
    @books = Book.all
  end

  def show
  end

  private

  def load_book
    @book = Book.find(params[:id])
  end

end
