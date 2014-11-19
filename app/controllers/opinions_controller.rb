class OpinionsController < ApplicationController

  def create
    @opinion = Opinion.new(opinion_params)
    current_user.opinions << @opinion
    if @opinion.save
      redirect_to book_path(id: @opinion.book_id)
    else
      flash[:error] = "Something wrong with your opinion"
    end
  end

  def vote
    @opinion = Opinion.find(params[:opinion])
    @opinion_rating = current_customer.opinion_ratings.create(rating:params[:rating],opinion_id:params[:opinion])
    @opinion.opinion_ratings << @opinion_rating
    redirect_to :back
  end

  private
  
  def opinion_params
    params.require(:opinion).permit(:score,:content,:book_id)
  end

end
