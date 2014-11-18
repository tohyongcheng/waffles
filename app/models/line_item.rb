class LineItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  def authors_list
    authors.map {|author| "#{author.full_name}"}.join(',')
  end
end
