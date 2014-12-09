# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p "SEEDING"
10.times do 
	Author.create(full_name: Faker::Name.name)
	Publisher.create(name: Faker::Company.name)
end


authors = Author.all
publishers = Publisher.all

publishers.each do |p|
	authors.each do |a|
		Book.create(isbn10: Faker::Code.isbn, isbn13: Faker::Code.ean, title: Faker::Commerce.product_name, publisher_id: p.id, publication_date: Faker::Date.between(10.years.ago,Date.today), copies: rand(5..30), price: Faker::Commerce.price, format: ["Hardcover", "Softcover"].sample, author_ids: [a.id])

  end
end

10.times do
  Customer.create(username: Faker::Internet.user_name, password: "123", full_name: Faker::Name.name)
end

subjects = %w(Sci-fi, Crime, Philosophy, Computer Science, Teens, Fantasy, Mature)
opinions = %w(WORST, BAD, OKAY, GOOD, BEST) 

Book.all.each do |book|
  if book.subjects.empty?
    book.subjects.create(name: subjects.sample)
  end
  [0,1,2].sample.times do
    author = Author.all.sample
    book.authors << author if not book.authors.include?(author)
  end
  number = [0..9].sample % 5
  opinion = Customer.all.sample.opinions.create(content: opinions[number], rating: number)
  book.opinions << opinion
  book.save
end
