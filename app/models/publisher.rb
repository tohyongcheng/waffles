class Publisher < ActiveRecord::Base
  has_many :books
  attr_accessor :count

  def self.raw_to_publishers(results)
    publishers = []
    results.each do |r|
      publishers << Publisher.hash_to_publisher(r)
    end
    publishers
  end

  def self.hash_to_publisher(publisher_hash)
    publisher = Publisher.new() 
    attrs = publisher_hash.reject{|k,v| !publisher.attributes.keys.member?(k.to_s) and k != "count" }
    publisher.attributes = attrs
    publisher
  end

  def self.best_sellers_this_month(m)
    m = 10 if m == ""
    result = Publisher.connection.execute("
      SELECT publishers.*, SUM(quantity) as count FROM (
        SELECT publisher_id, quantity
        FROM line_items
        JOIN books ON line_items.book_id = books.id
        JOIN orders ON order_id = orders.id
        JOIN publishers ON publishers.id = books.publisher_id 
        WHERE line_items.created_at BETWEEN '#{Time.now.beginning_of_month.utc}' AND '#{Time.now.end_of_month.utc}'
        AND orders.status = 1

        UNION ALL

        SELECT id as publisher_id, 0 as quantity FROM publishers
      ) as temp
      JOIN publishers on publisher_id = publishers.id
      GROUP BY publishers.id
      ORDER BY count DESC
      LIMIT #{m}
    ")

    raw_to_publishers result
  end
end
