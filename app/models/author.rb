class Author< ActiveRecord::Base
  has_and_belongs_to_many :books
  attr_accessor :count

  def self.raw_to_authors(results)
    authors = []
    results.each do |r|
      authors << Author.hash_to_author(r)
    end
    authors
  end

  def self.hash_to_author(author_hash)
    author = Author.new() 
    attrs = author_hash.reject{|k,v| !author.attributes.keys.member?(k.to_s) and k != "count" }
    author.attributes = attrs
    author
  end

  def self.best_sellers_this_month(m)
    # result = Author.connection.execute("
    #   SELECT authors.*, SUM(quantity) as count
    #   FROM line_items
    #   JOIN authors on authors_books.author_id = authors.id
    #   JOIN authors_books ON line_items.book_id = authors_books.book_id
    #   JOIN orders ON order_id = orders.id
    #   WHERE line_items.created_at BETWEEN '#{Time.now.beginning_of_month.utc}' AND '#{Time.now.end_of_month.utc}'
    #   AND orders.status = 1
    #   GROUP BY author_id
    #   ORDER BY count DESC
    #   LIMIT #{m}
    # ")
    result = Author.connection.execute("
      SELECT authors.*, SUM(quantity) as count FROM (
        SELECT ALL author_id, quantity
        FROM line_items
        JOIN authors_books ON line_items.book_id = authors_books.book_id
        JOIN orders ON order_id = orders.id
        WHERE line_items.created_at BETWEEN '#{Time.now.beginning_of_month.utc}' AND '#{Time.now.end_of_month.utc}'
        AND orders.status = 1

        UNION ALL

        SELECT id as author_id, 0 as quantity FROM authors
      )
      JOIN authors on author_id = authors.id
      GROUP BY author_id
      ORDER BY count DESC
      LIMIT #{m}
    ")

    raw_to_authors result
  end
end
