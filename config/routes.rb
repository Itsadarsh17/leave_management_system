Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: [:index,:show] do
    member do
      post 'promote_to_admin'
      get 'leave_details'
    end
  end

  resources :leave_applications do
    member do
      put :accept
      put :reject
    end
  end

  authenticated :user, ->(u) { u.admin? } do
    get '/admin_dashboard', to: 'admin_dashboard#index'
    get '/leave_request', to: 'admin_dashboard#leave_request'
  end

  authenticated :user do
    get '/user_dashboard', to: 'dashboard#index' , as: 'user_dashboard'
  end

  unauthenticated do
    root 'leave_applications#index'
  end
end
