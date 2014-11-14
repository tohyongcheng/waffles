class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :username, :unique
      t.string :password
      t.string :credit_card
      t.string :address
      t.string :phone
      t.timestamps
    end
  end
end
