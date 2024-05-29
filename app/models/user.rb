class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :leave_applications, foreign_key: :user_id ,  dependent: :destroy
  has_many :approved_leave_applications, foreign_key: :approver_id, class_name: 'LeaveApplication',  dependent: :destroy
  has_many :backup_leave_applications, foreign_key: :backup_user_id, class_name: 'LeaveApplication', dependent: :destroy
  belongs_to :admin_role, foreign_key: "admin_role_id", optional: true

  validates :email, uniqueness: true
  validates :first_name , :last_name , presence: true

  SICK_LEAVE_LIMIT = 7
  CASUAL_LEAVE_LIMIT = 15

  def remaining_sick_leaves_taken_this_year
    sick_leaves_taken_this_year = leave_applications.where(leave_type: 'sick_leave',status: 1 ,start_date: Date.current.beginning_of_year..Date.current.end_of_year).sum(&:leave_days)
    sick_leave=  SICK_LEAVE_LIMIT - sick_leaves_taken_this_year
    remaining = [sick_leave,0].max
  end

  def remaining_casual_leaves_taken_this_year
    casual_leaves_taken_this_year= leave_applications.where(leave_type: 'casual_leave',status: 1, start_date: Date.current.beginning_of_year..Date.current.end_of_year).sum(&:leave_days)
    casual_leave= CASUAL_LEAVE_LIMIT - casual_leaves_taken_this_year
    remaining = [casual_leave,0].max
  end

  def paid_leaves_count
    leave_applications.where(leave_type: 'sick_leave', status: 'approved').sum(&:leave_days)
  end

  def unpaid_leaves_count
    leave_applications.where(leave_type: 'unpaid_leave', status: 'approved').sum(&:leave_days)
  end

  def pending_leaves_count
    leave_applications.where(status: 'pending').sum(&:leave_days)
  end

  def approved_upcoming_leaves_count
    leave_applications.where('start_date >= ? AND status = ?', Date.today, 1).sum(&:leave_days)
  end

  def admin?
    admin_role.present?
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def self.admin_users
    User.joins(:admin_role).where(admin_roles: { name: 'admin' })
  end

  def self.non_admin_users
    User.where(admin_role_id: nil)
  end
end
