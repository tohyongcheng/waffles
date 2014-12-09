class OpinionRating < ActiveRecord::Base
  belongs_to :opinion
  belongs_to :customer

  include ResultsHelper

  def self.raw_to_opinion_ratings(results)
    ResultsHelper.raw_to_model(results, self.name)
  end
end
