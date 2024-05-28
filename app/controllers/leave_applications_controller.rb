require 'csv'
class LeaveApplicationsController < ApplicationController
  before_action :set_leave_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def export_csv
    @leave_applications = LeaveApplication.all
    respond_to do |format|
      format.csv { send_data generate_csv(@leave_applications), filename: "leave_applications-#{Date.today}.csv" }
    end
  end

  def index
    @leave_applications = if current_user.admin?
                            LeaveApplication.page(params[:page]).per(10)
                          else
                            current_user.leave_applications.page(params[:page]).per(10)
                          end
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
      LeaveApplicationMailer.notify_approver(@leave_application).deliver_later
      redirect_to @leave_application, notice: 'Leave application was successfully created.'
    else
      render :new
    end
  end

  def update
    if @leave_application.update(leave_application_params)
      LeaveApplicationMailer.notify_user(@leave_application).deliver_later
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
      params.require(:leave_application).permit(:reason, :start_date, :end_date, :leave_type, :leave_days, :approver_id, :backup_user_id)
    end

    def generate_csv(leave_applications)
      CSV.generate(headers: true) do |csv|
        csv << ['Reason', 'Start Date', 'End Date', 'Leave Type', 'Leave Days', 'User Email', 'Status', 'Backup User Email']

        leave_applications.each do |leave_application|
          csv << [
            leave_application.reason,
            leave_application.start_date,
            leave_application.end_date,
            leave_application.leave_type,
            leave_application.leave_days,
            leave_application.user.email,
            leave_application.status,
            leave_application.backup_user.email
          ]
        end
      end
    end
  end