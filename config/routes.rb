Rails.application.routes.draw do
  root 'leave_applications#index'
  devise_for :users

  resources :users
  resources :roles
  resources :leave_applications

end
