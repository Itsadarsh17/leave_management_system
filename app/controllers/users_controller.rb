class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:index]
  before_action :set_users, only: [:leave_details, :show]

  def index
    @users = User.all
  end

  def find_admin
    @admins = User.admin_users
  end

  def show
  end

  def leave_details
    @leave_applications = @user.leave_applications.paginate(page: params[:page], per_page: 5)
    @monthly_leaves = @leave_applications.group_by { |leave| leave.start_date.beginning_of_month }
  end

  private

  def set_users
    @user = User.find(params[:id])
  end

  def authorize_admin
    redirect_to(root_path, alert: "Access denied.") unless current_user.admin_users?
  end
end
