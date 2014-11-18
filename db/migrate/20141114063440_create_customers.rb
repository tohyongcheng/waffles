class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :full_name, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.string :credit_card
      t.string :address
      t.string :phone
      t.index  :username, unique: true
      t.timestamps
    end
  end
end
