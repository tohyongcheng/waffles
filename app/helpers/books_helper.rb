module BooksHelper
  def opinion_score(score)
    if score.nil? 
      score = 0
    end
    output = ""
    score.times {output+="<span>★</span>"}
    (10-score).times {output+="<span>☆</span>"}
    return output
  end
end
