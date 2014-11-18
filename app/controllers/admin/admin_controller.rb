class Admin::AdminController < ActionController::Base
	http_basic_authenticate_with name: "admin", password: "admin"
	layout 'admin'
	def index
		@books = Book.all
	end
end