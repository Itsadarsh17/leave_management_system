class AddMonthlyLeaveWorker
  include Sidekiq::Worker

  LEAVE_AMOUNT = 1.25

  def perform
    User.all.map do |user|
      user.leave_balance +=  LEAVE_AMOUNT
      user.save
    end
  end
end