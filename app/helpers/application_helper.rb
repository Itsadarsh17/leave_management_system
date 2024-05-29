module ApplicationHelper
  def user_admin?
    current_user == 'admin'
  end
end
