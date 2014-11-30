class Admin::StatsController < Admin::AdminController
  def index
    render '/admin/stats/index'
  end

  def books
    params[:count]||= 10
    @books = Book.best_sellers_this_month(params[:count])
    render '/admin/stats/books'
  end
end
