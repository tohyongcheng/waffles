class AddNotNullConstraintsToBooks < ActiveRecord::Migration
  def change
    change_column :books, :isbn10, :string, :null => false
    change_column :books, :isbn13, :string, :null => false
    change_column :books, :title, :string, :null => false
    change_column :books, :publisher_id, :integer, :null => false
    change_column :books, :publication_date, :date, :null => false
    change_column :books, :copies, :integer, default: 0, :null => false
    change_column :books, :format, :string, :null => false
  end
end
