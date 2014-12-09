class AddUniqueConstraintToBookIsbn < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE books ADD CONSTRAINT book_isbn13_unique UNIQUE (isbn13)"
    execute "ALTER TABLE books ADD CONSTRAINT book_isbn10_unique UNIQUE (isbn10)"
  end

  def self.down
    execute "ALTER TABLE books DROP CONSTRAINT book_isbn13_unique"
    execute "ALTER TABLE books DROP CONSTRAINT book_isbn10_unique"
  end
end
