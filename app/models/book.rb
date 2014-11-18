class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors
  belongs_to :publisher

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end

  def publisher_name
    try(:publisher).try(:name)
  end
end
