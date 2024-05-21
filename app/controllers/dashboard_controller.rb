class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @leave_applications = current_user.leave_applications
    @user = current_user
  end
end
