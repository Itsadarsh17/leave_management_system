class AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
    @user_data = @users.map do |user|
      {
        id: user.id,
        email: user.email,
        paid_leaves: user.paid_leaves_count,
        unpaid_leaves: user.unpaid_leaves_count,
        pending_leave_requests: user.pending_leaves_count,
        approved_upcoming_leaves: user.approved_upcoming_leaves_count,
        remaining_sick_leaves_taken_this_year: user.remaining_sick_leaves_taken_this_year,
        total_balance: user.total_leave_balance,
        remaining_casual_leaves_taken_this_year: user.remaining_casual_leaves_taken_this_year
      }
    end
  end

  def leave_request
    @leave_applications = LeaveApplication.where(status: 0)
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
