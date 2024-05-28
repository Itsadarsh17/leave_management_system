class AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  def index
    @users = User.all.includes(:leave_applications)
    @user_data = @users.map do |user|
      {
        id: user.id,
        email: user.email,
        leaves_taken: user.leaves_taken,
        paid_leaves: user.paid_leaves,
        unpaid_leaves: user.unpaid_leaves,
        pending_leave_requests: user.pending_leaves,
        approved_upcoming_leaves: user.approved_upcoming_leaves
      }
    end
  end

  def leave_request
    @leave_applications = LeaveApplication.where(status: 'pending')
  end


  private

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
