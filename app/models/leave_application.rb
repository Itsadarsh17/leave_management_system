class LeaveApplication < ApplicationRecord
  belongs_to :user
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id', optional: true
  belongs_to :backup_user, class_name: 'User', foreign_key: 'backup_user_id', optional: true

  enum leave_type: { sick_leave: 0, casual_leave: 1, unpaid_leave: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :reason, :start_date, :end_date, :leave_type, presence: true
  validates :user, presence: true  # Ensure user is always present
  validate :end_date_greater_than_start_date
  validate :start_date_today_or_greater

  private

  def end_date_greater_than_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "must be greater than start date")
    end
  end

  def start_date_today_or_greater
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "must be today or greater")
    end
  end
end