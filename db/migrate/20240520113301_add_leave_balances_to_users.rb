class AddLeaveBalancesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :yearly_leave_balance, :float
    add_column :users, :total_casual_leaves, :float
    add_column :users, :total_sick_leaves, :float
  end
end
