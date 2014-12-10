class AddUniqueConstraintToOpinions < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE opinions ADD CONSTRAINT opinions_book_user_unique UNIQUE (customer_id, book_id)"
  end

  def self.down
    execute "ALTER TABLE opinions DROP CONSTRAINT opinions_book_customer_unique"
  end
end
