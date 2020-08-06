Rails.application.routes.draw do
  root 'statics#top'
  get 'statics/privacy', to: 'statics#privacy'
  get 'statics/support', to: 'statics#support'
  get 'statics/support', to: 'statics#support'
  get 'statics/overview', to: 'statics#overview'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  resources :users, only: [:show, :index]
  namespace :admin do
    resources :users, only: [:edit, :update]
  end
  resources :collected_shifts, except: [:show, :new] do
    resources :created_shifts, only: [:create, :destroy], module: 'admin'
  end
  resources :created_shifts, only: [:index], module: 'admin'
  resources :attendances, except: [:show]
  resources :companies, except: [:index, :destroy] do
    member do
      post :regenerate
    end
  end
end
