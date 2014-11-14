class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.integer :book_id
      t.integer :customer_id
      t.integer :score
      t.text    :content

      t.timestamps
    end
  end
end
