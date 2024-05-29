namespace :add_monthly_leave do
  desc 'Add Monthly leave to users'
  task run: :environment do
    LEAVE_AMOUNT = 1.25

    User.all.map do |user|
      user.leave_balance +=  LEAVE_AMOUNT
      user.save
    end
  end
end