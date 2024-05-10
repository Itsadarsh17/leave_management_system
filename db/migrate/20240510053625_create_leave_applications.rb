class CreateLeaveApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :leave_applications do |t|
      t.text :reason
      t.date :start_date
      t.date :end_date
      t.integer :leave_type, default: 0
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.references :approver, foreign_key: { to_table: :users }
      t.references :backup_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end