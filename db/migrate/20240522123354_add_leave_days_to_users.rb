class AddLeaveDaysToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :leave_applications, :leave_days, :float, default: 0.0
  end
end
