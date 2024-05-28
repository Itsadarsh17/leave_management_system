class User < ApplicationRecord

  has_many :leave_applications, foreign_key: :user_id ,  dependent: :destroy
  has_many :approved_leave_applications, foreign_key: :approver_id, class_name: 'LeaveApplication',  dependent: :destroy
  has_many :backup_leave_applications, foreign_key: :backup_user_id, class_name: 'LeaveApplication', dependent: :destroy
  belongs_to :admin_role, foreign_key: "admin_role_id", optional: true

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  validates :first_name , :last_name , presence: true

  # Constants for leave policies
  CASUAL_LEAVE_LIMIT = 15
  SICK_LEAVE_LIMIT = 7
  MONTHLY_LEAVE = 1.25

  # after_initialize :initialize_leave_days, if: :new_record?

  
  # def initialize_leave_balances
  #   self.total_casual_leaves ||= 0.0
  #   self.total_sick_leaves ||= 0.0
  #   self.leave_balance ||= 0.0
  #   self.last_accrual_date ||= Date.today.beginning_of_month
  # end



 
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

  def remaining_monthly_leaves_taken
    monthly_paid_leave = 1.25
    current_month_start = Date.current.beginning_of_month
    current_month_end = Date.current.end_of_month
  
    # Calculate the total leave days taken in the current month
    current_month_leaves = leave_applications
                             .where(status: 1, start_date: current_month_start..current_month_end)
                             .sum(&:leave_days)
  
    # Calculate the remaining paid leaves
    remaining_paid_leaves = monthly_paid_leave - current_month_leaves
  
    if remaining_paid_leaves >= 0
      paid_leaves_taken = current_month_leaves
      unpaid_leaves_taken = 0
    else
      paid_leaves_taken = monthly_paid_leave
      unpaid_leaves_taken = current_month_leaves - monthly_paid_leave
    end
    reamining_leaves =  [remaining_paid_leaves, 0].max
       
  end
  
  def leaves_taken
    leave_applications.where('created_at >= ?', Time.current.beginning_of_year).sum(&:leave_days)
  end

  def paid_leaves
    leave_applications.where(leave_type: 'sick_leave', status: 'approved').sum(&:leave_days)
  end

  def unpaid_leaves
    leave_applications.where(leave_type: 'unpaid_leave', status: 'approved').sum(&:leave_days)
  end

  def pending_leaves
    leave_applications.where(status: 'pending').sum(&:leave_days)
  end

  def approved_upcoming_leaves
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

  # def months_since_start_of_year
  #   (Time.current.month - 1) + (Time.current.day > 1 ? 1 : 0)
  # end
end
