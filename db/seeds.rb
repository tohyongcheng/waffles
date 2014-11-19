# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
