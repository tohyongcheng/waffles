class Book < ActiveRecord::Base
  has_and_belongs_to_many :authors

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end
end
