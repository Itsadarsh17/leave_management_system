class AddLeaveBalancesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :unpaid_leaves, :float, default: 0.0
    add_column :users, :total_casual_leaves, :float, default: 0.0
    add_column :users, :total_sick_leaves, :float, default: 0.0
  end
end
