class LeaveApplicationsController < ApplicationController
  before_action :set_leave_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @leave_applications = LeaveApplication.all
  end

  def show
  end

  def new
    @leave_application = LeaveApplication.new
  end

  def edit
  end

  def create
    @leave_application = LeaveApplication.new(leave_application_params)

    if @leave_application.save
      redirect_to @leave_application, notice: 'Leave application was successfully created.'
    else
      render :new
    end
  end

  def update
    if @leave_application.update(leave_application_params)
      redirect_to @leave_application, notice: 'Leave application was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @leave_application.destroy
    redirect_to leave_applications_url, notice: 'Leave application was successfully destroyed.'
  end

  private
    def set_leave_application
      @leave_application = LeaveApplication.find(params[:id])
    end

    def leave_application_params
      params.require(:leave_application).permit(:reason, :start_date, :end_date, :leave_type, :approver_id, :backup_user_id)
    end
end
