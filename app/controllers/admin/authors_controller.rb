class Admin::AuthorsController < Admin::AdminController

	def create
		@author = Author.create author_params
    redirect_to admin_root_path
	end

	def new 
		@author = Author.new
	end

	private
	
	def author_params
    params.require(:author).permit(:full_name)
  end

end