class OpinionRating < ActiveRecord::Base
  belongs_to :opinion
  belongs_to :customer
end
