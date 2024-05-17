class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :encrypted_password
      t.decimal :leave_balance, precision: 8, scale: 2, default: 0.0
      
      t.timestamps
    end
   

    add_index :users, :email, unique: true
  end
end

