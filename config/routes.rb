Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: [:index,:show] do
    member do
      get 'leave_details'
      post :accrue_leaves
    end
  end

  resources :leave_applications do
    member do
      put :accept
      put :reject
    end
    collection do
      get :export_csv
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
