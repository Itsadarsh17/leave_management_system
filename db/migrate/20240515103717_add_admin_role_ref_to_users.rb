class AddAdminRoleRefToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :admin_role, foreign_key: true
  end
end
