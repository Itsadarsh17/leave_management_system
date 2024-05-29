class LeaveApplicationsController < ApplicationController
  before_action :set_leave_application, only: [:show, :edit, :update, :destroy, :accept, :reject]
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
    @leave_application = current_user.leave_applications.build(leave_application_params)

    if @leave_application.save
      redirect_to @leave_application, notice: 'Leave application is successfully created.'
    else
      render :new
    end
  end

  def update
    if @leave_application.update(leave_application_params)
      redirect_to @leave_application, notice: 'Leave application is successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @leave_application.destroy
    redirect_to leave_applications_url, notice: 'Leave application is successfully destroyed.'
  end

  def accept
    if @leave_application.update(status: 'approved')
      redirect_to leave_application_path(@leave_application), notice: 'Leave application is successfully accepted.'
    else
      @leave_application.errors.full_messages.join(', ')
    end
  end

  def reject

    if @leave_application.update(status: 'rejected')
      redirect_to leave_application_path(@leave_application), notice: 'Leave application is successfully rejected.'
    else
      @leave_application.errors.full_messages.join(', ')
    end
  end


  private
    def set_leave_application
      @leave_application = LeaveApplication.find(params[:id])
    end

    def leave_application_params
      params.require(:leave_application).permit(:reason, :start_date, :end_date, :leave_type, :approver_id, :backup_user_id)
    end
end
