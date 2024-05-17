# app/controllers/admin_dashboard_controller.rb
class AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
    @leave_applications = LeaveApplication.all
  end

  def promote_to_admin
    @user = User.find(params[:id])
    @user.update(admin_role: AdminRole.first_or_create) unless @user.admin?
    redirect_to admin_dashboard_path, notice: "#{@user.email} has been promoted to admin."
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
