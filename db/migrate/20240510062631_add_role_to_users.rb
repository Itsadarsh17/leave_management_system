class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :role, foreign_key: true, default: 1
  end
end
