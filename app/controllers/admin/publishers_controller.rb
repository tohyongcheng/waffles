class Admin::PublishersController < Admin::AdminController
  def index
    @publishers = Publisher.all
  end

  def create
    @publisher = Publisher.create publisher_params
    redirect_to admin_root_path
  end

  def new
    @publisher = Publisher.new
  end

  def edit
    @publisher = Publisher.find(params[:id])
  end

  def update
    @publisher = Publisher.find(params[:id])
    @publisher.update_attributes publisher_params
    redirect_to admin_root_path
  end

  private

  def publisher_params
    params.require(:publisher).permit(:name)
  end

end