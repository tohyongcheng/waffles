class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  belongs_to :publisher
  has_many :opinions

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end

  def publisher_name
    try(:publisher).try(:name)
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
      joins(:opinion_ratings).
      joins(:book).
      where("books.id = #{id}").
      group(:opinion_id).order('average DESC').
      limit(number)
  end

end
