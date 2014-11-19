class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string  :isbn10 #unique
      t.string  :isbn13 #unique
      t.string  :title
      t.integer :publisher_id
      t.date    :publication_date
      t.integer :copies
      t.decimal :price
      t.string  :format #constraint hard/softcover
      #has many subjects, keywords, author
      t.timestamps
    end
  end
end
