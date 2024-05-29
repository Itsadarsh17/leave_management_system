class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :leave_applications, foreign_key: :user_id
  has_many :approved_leave_applications, foreign_key: :approver_id, class_name: 'LeaveApplication'
  has_many :backup_leave_applications, foreign_key: :backup_user_id, class_name: 'LeaveApplication'
  belongs_to :admin_role, foreign_key: "admin_role_id", optional: true

  validates :email, uniqueness: true

  # Constants for leave policies
  CASUAL_LEAVE_LIMIT = 15
  SICK_LEAVE_LIMIT = 7
  MONTHLY_LEAVE_ACCRUAL = 1.25



  # Method to accrue monthly leaves
  def accrue_monthly_leaves
    self.leave_balance += MONTHLY_LEAVE_ACCRUAL
    save
  end

  # Method to calculate yearly leave balances
  def remaining_leaves_this_month
    casual_leaves_taken_this_month = leave_applications.where(leave_type: 'casual_leave', start_date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:leave_days)
    sick_leaves_taken_this_month = leave_applications.where(leave_type: 'sick_leave', start_date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:leave_days)

    [CASUAL_LEAVE_LIMIT - casual_leaves_taken_this_month, SICK_LEAVE_LIMIT - sick_leaves_taken_this_month].min
  end


  # Method to apply for a leave
  def apply_leave(leave_type, start_date, end_date)
    transaction do
      leave_days = (end_date - start_date).to_i + 1

      case leave_type
      when 'casual_leave'
        if total_casual_leaves >= leave_days
          self.total_casual_leaves -= leave_days
        else
          self.leave_balance -= (leave_days - total_casual_leaves)
          self.total_casual_leaves = 0
        end
      when 'sick_leave'
        if total_sick_leaves >= leave_days
          self.total_sick_leaves -= leave_days
        else
          self.leave_balance -= (leave_days - total_sick_leaves)
          self.total_sick_leaves = 0
        end
      else
        self.leave_balance -= leave_days
      end

      save
    end
  end

  def self.add_monthly_leave_balance
    all.find_each do |user|
      user.accrue_monthly_leaves
    end
  end

  # Method to calculate leaves taken in the current year
  def leaves_taken
    leave_applications.where('created_at >= ?', Time.current.beginning_of_year).count
  end

  def paid_leaves
    leave_applications.where(leave_type: 'sick_leave', status: 'approved').count
  end

  def unpaid_leaves
    leave_applications.where(leave_type: 'unpaid_leave', status: 'approved').count
  end

  def pending_leaves
    leave_applications.where(status: 'pending').count
  end

  def approved_upcoming_leaves
    leave_applications.where('start_date >= ? AND status = ?', Date.today, 1).count
  end

  def admin?
    admin_role.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.admin_users
    User.joins(:admin_role).where(admin_roles: { name: 'admin' })
  end

  def self.non_admin_users
    User.where(admin_role_id: nil)
  end



  # Calculate the number of months since the start of the year
  def months_since_start_of_year
    (Time.current.month - 1) + (Time.current.day > 1 ? 1 : 0)
  end
end
