class OpinionsController < ApplicationController

  before_filter :authenticate_customer!, only: [:index, :usefulness]

  def index
    @opinions = current_customer.opinions    
  end

  def create
    @opinion = Opinion.new(opinion_params)
    current_customer.opinions << @opinion
    if @opinion.save
      flash[:notice] = "Comment Added!"
      redirect_to book_path(id: @opinion.book_id)
    else
      flash[:error] = @opinion.errors.full_messages.to_sentence
      redirect_to book_path(id: @opinion.book_id)
    end
  end

  def vote
    @opinion = Opinion.find(params[:opinion])
    @opinion_rating = current_customer.opinion_ratings.create(rating:params[:rating],opinion_id:params[:opinion])
    @opinion.opinion_ratings << @opinion_rating
    flash[:notice] = "Thanks for voting!"
    redirect_to :back
  end

  def usefulness
    @opinion_ratings = current_customer.opinion_ratings
  end

  private
  
  def opinion_params
    params.require(:opinion).permit(:score,:content,:book_id)
  end

end
