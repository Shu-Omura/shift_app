Rails.application.routes.draw do
  root "statics#top"
  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks",
  }
  resources :users, only: [:show, :index]
  resources :collected_shifts, except: [:show, :new] do
    resources :created_shifts, only: [:create, :destroy], module: 'admin'
  end
  resources :created_shifts, only: [:index], module: 'admin'
  resources :attendances, except: [:show]
end
