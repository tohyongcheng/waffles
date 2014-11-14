class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :quantity
      t.integer :book_id
      t.timestamps
      #price of the book. what happens when the price changes before and after checkout
    end
  end
end
