class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  belongs_to :publisher
  has_many :opinions
  attr_accessor :count

  def self.hash_to_book(book_hash)
    book = Book.new() 
    attrs = book_hash.reject{|k,v| !book.attributes.keys.member?(k.to_s) and k != "count" }
    book.attributes = attrs
    return book
  end

  def self.best_sellers_this_month(m)
    result = Book.connection.execute("
      SELECT books.* , SUM(quantity) as count
      FROM line_items JOIN books JOIN orders
      WHERE line_items.created_at BETWEEN '#{Time.now.beginning_of_month}' AND '#{Time.now.end_of_month}'
      AND orders.status = 1

      UNION

      SELECT *, 0 as count
      FROM books

      GROUP BY books.id
      ORDER BY count DESC
      LIMIT #{m}
      ")

    books = []
    result.each do |book_hash|
      books << Book.hash_to_book(book_hash)
    end
    return books
  end


  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end

  def publisher_name
    try(:publisher).try(:name)
  end

  def copies_sold_this_month(m)
    result = ActiveRecord::Base.connection.execute("
      SELECT SUM(quantity) as count
      FROM line_items JOIN orders
      WHERE book_id = #{id}
      AND orders.status = 1
      AND line_items.created_at BETWEEN '#{Time.now.beginning_of_month}' AND '#{Time.now.end_of_month}'
      ORDER BY count DESC
      LIMIT #{m}
    ")
    return result[0]["count"] if result.any? 
    return 0
  end

  def useful_opinions(number: 5)

    # SELECT  opinions.id, opinions.customer_id, opinions.created_at, opinions.score, opinions.content, full_name, avg(rating) as average 
    # FROM "opinions" 
    # INNER JOIN "customers" ON "customers"."id" = "opinions"."customer_id" 
    # INNER JOIN "opinion_ratings" ON "opinion_ratings"."opinion_id" = "opinions"."id"
    # GROUP BY opinion_id  
    # ORDER BY average DESC 
    # LIMIT 5
    
    Opinion.select('opinions.id, opinions.customer_id, opinions.created_at, opinions.score, opinions.content, full_name, avg(rating) as average').
      joins(:customer).
      joins("LEFT OUTER JOIN opinion_ratings ON opinions.id = opinion_ratings.opinion_id").
      where(book_id: id).
      group(:opinion_id).order('average DESC').
      limit(5)
  end

end
