class CreateOpinionRatings < ActiveRecord::Migration
  def change
    create_table :opinion_ratings do |t|
      t.integer :customer_id
      t.integer :opinion_id
      t.integer :rating
      t.timestamps
    end
  end
end
