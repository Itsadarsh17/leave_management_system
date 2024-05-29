every 1.month, at: 'start of the month at 00:00 am' do
  runner "User.add_monthly_leave_balance"
end
