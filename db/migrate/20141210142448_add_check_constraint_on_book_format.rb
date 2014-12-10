class AddCheckConstraintOnBookFormat < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE books ADD CONSTRAINT book_format_constraint CHECK (format IN ('softcover' , 'hardcover'))"
  end

  def self.down
    execute "ALTER TABLE books DROP CONSTRAINT book_format_constraint"
  end
end
