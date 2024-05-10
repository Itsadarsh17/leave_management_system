class User < ApplicationRecord

  belongs_to :role
  has_many :leave_applications, foreign_key: :user_id
  has_many :approved_leave_applications, foreign_key: :approver_id, class_name: 'LeaveApplication'
  has_many :backup_leave_applications, foreign_key: :backup_user_id, class_name: 'LeaveApplication'

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
