class AddSubjectsToBooks < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
    end
    create_join_table :books, :subjects do |t|
      t.index [:book_id, :subject_id]
      t.index [:subject_id, :book_id]
    end
  end
end
