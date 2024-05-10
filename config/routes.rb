Rails.application.routes.draw do
  root 'dashboard#index'
  devise_for :users

  resources :users
  resources :roles
  resources :leave_applications

end
