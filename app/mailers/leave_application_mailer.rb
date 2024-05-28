class LeaveApplicationMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def notify_approver(leave_application)
    @leave_application = leave_application
    mail(to: @leave_application.backup_user.email, subject: 'New Leave Application Request')
  end

  def notify_user(leave_application)
    @leave_application = leave_application
    mail(to: @leave_application.user.email, subject: 'Leave Application Status Update')
  end
end