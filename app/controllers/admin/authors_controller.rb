class Admin::AuthorsController < Admin::AdminController

  def index
    @authors = Author.all
  end

	def create
		@author = Author.create author_params
    redirect_to admin_root_path
	end

	def new
		@author = Author.new
	end

  def edit
    @author = Author.find(params[:id])
  end

  def update
    @author = Author.find(params[:id])
    @author.update_attributes author_params
    redirect_to admin_root_path
  end

	private

	def author_params
    params.require(:author).permit(:full_name)
  end

end