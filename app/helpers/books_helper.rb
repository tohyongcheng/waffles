module BooksHelper
  def opinion_score(score)
    output = ""
    score.times {output+="<span>★</span>"}
    (10-score).times {output+="<span>☆</span>"}
    return output
  end
end
