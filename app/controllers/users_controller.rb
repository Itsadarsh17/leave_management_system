class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:promote_to_admin, :index]

  def index
    @users = User.all
  end

  def promote_to_admin
    user = User.find(params[:id])
    admin_role = AdminRole.first_or_create(name: 'Admin') # Ensure there's at least one admin role
    user.update(admin_role: admin_role)
    if user.save
      redirect_to users_path, notice: "#{user.email} has been promoted to admin."
    else
      redirect_to users_path, alert: "Failed to promote #{user.email} to admin."
    end

  def find_admin
    @admins = User.admin_users
  end

  def show
    @user = User.find(params[:id])
    @leave_summary = @user.remaining_monthly_leaves_taken
  end

  def leave_details
    @user = User.find(params[:id])
    @leave_applications = @user.leave_applications
    @monthly_leaves = @leave_applications.group_by { |leave| leave.start_date.beginning_of_month }
  end

  private

  def authorize_admin
    redirect_to(root_path, alert: "Access denied.") unless current_user.admin_users?
  end
end
