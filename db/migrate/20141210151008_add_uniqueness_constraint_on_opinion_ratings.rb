class AddUniquenessConstraintOnOpinionRatings < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE opinion_ratings ADD CONSTRAINT opinions_ratings_opinion_user_unique UNIQUE (customer_id, opinion_id)"
  end

  def self.down
    execute "ALTER TABLE opinion_ratings DROP CONSTRAINT opinions_ratings_opinion_user_unique"
  end
end
