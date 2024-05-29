every '0 0 1 * *' do
  runner "AddMonthlyLeaveWorker.perform_async"
end
