class Admin::BooksController < Admin::AdminController

  before_filter :load_book, except: [:index, :new, :create]
  def new
    @book = Book.new
  end

  def create
    p book_params
    @book = Book.create book_params
    if @book.save
      flash[:error] = @book.errors.full_messages.to_sentence
      redirect_to admin_root_path
    else
      render :new 
    end
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
    redirect_to admin_root_path
  end

  private

  def load_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :publisher_id, :subject_ids, :price, :isbn10, :isbn13, :copies,  :publication_date, :format, :author_ids => [], :subject_ids => [])
  end
end
