class LeaveApplication < ApplicationRecord
  belongs_to :user
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id', optional: true
  belongs_to :backup_user, class_name: 'User', foreign_key: 'backup_user_id', optional: true

  enum leave_type: { sick_leave: 0, casual_leave: 1, unpaid_leave: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :reason, :start_date, :end_date, :leave_type, presence: true
  validates :user, presence: true  
  validate :end_date_greater_than_start_date
  validate :check_leave_limits, on: :create

  def leave_days
    if start_date && end_date
      (end_date - start_date).to_i + 1
    else
      0
    end
  end

  private

  def end_date_greater_than_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "must be greater than start date")
    end
  end
  
  def check_leave_limits
    if leave_type == 'sick_leave' && user.remaining_sick_leaves_taken_this_year <= 0
      errors.add(:base, "You have exceeded the limit for sick leaves")
      throw(:abort)
    end
    if leave_type == 'casual_leave' && user.remaining_casual_leaves_taken_this_year <= 0
      errors.add(:base, "You have exceeded the limit for casual leaves")
      throw(:abort)
    end

  end
end