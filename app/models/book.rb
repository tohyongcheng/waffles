class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  belongs_to :publisher
  has_many :opinions
  has_and_belongs_to_many :subjects
  attr_accessor :count
  validates_presence_of :authors
  validates_presence_of :subjects

  def self.raw_to_books(results)
    books = []
    results.each do |r|
      books << Book.hash_to_book(r)
    end
    books
  end

  def self.hash_to_book(book_hash)
    book = Book.new() 
    attrs = book_hash.reject{|k,v| !book.attributes.keys.member?(k.to_s) and k != "count" }
    book.attributes = attrs
    book
  end

  def self.search(search_params)
    start = false
    query = ""
    if not search_params[:title].empty?
      query.concat "books.title LIKE '%#{search_params[:title]}%' "
      start = true
    end
    if not search_params[:publisher].empty?
      concat_conjunctive(query,start,search_params[:and_publisher])
      query.concat "publishers.name LIKE '%#{search_params[:publisher]}%' "
      start = true
    end
    if not search_params[:author].empty?
      concat_conjunctive(query,start,search_params[:and_author])
      query.concat "authors.full_name LIKE '%#{search_params[:author]}%' "
      start = true
    end
    if not search_params[:subject].empty?
      concat_conjunctive(query,start,search_params[:and_subject])
      query.concat "subjects.name LIKE '%#{search_params[:subject]}%' "
      start = true
    end
    result = Book.
      select('distinct(books.id), books.title, books.id, books.publication_date, coalesce(avg(score),0) as average').
      joins(:publisher).
      joins(:authors).
      joins("LEFT OUTER JOIN books_subjects ON books_subjects.book_id = books.id").
      joins("LEFT OUTER JOIN subjects ON books_subjects.subject_id = subjects.id").
      joins("LEFT OUTER JOIN opinions ON opinions.book_id = books.id").
      where(query).
      group("books.id").
      order("#{get_order_by_attr(search_params[:sort_by])} DESC")
    return result
  end

  def self.best_sellers_this_month(m)
    m = 10 if m == ""
    result = Book.connection.execute("
      SELECT books.*, SUM(quantity) as count FROM (
        SELECT book_id , quantity
        FROM line_items 
        JOIN orders on order_id = orders.id
        WHERE line_items.created_at BETWEEN '#{Time.now.beginning_of_month.utc}' AND '#{Time.now.end_of_month.utc}'
        AND orders.status = 1

        UNION ALL

        SELECT id as book_id , 0 as quantity FROM books
      ) as temp
      JOIN books on books.id = book_id
      GROUP BY books.id
      ORDER BY count DESC
      LIMIT #{m}
    ")
    raw_to_books result
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

  def all_opinions
    Opinion.select('opinions.*').where(book_id: id) 
  end

  def useful_opinions(number)
    number = 5 if number == ""
    Opinion.select('opinions.*, coalesce(avg(rating),0) as average').
      joins(:customer).
      joins("LEFT OUTER JOIN opinion_ratings ON opinions.id = opinion_ratings.opinion_id").
      where(book_id: id).
      group('opinions.id').order('average DESC').
      limit(number)
  end

  private
  
  def self.get_order_by_attr(sort_by)
    if sort_by == '0'
      return 'average'
    else
      return 'publication_date'
    end
  end

  def self.concat_conjunctive(query, start, and_or_value)
    if start 
      if and_or_value == '1'
        query.concat "and "
      else
        query.concat "or "
      end
    end
  end
end
