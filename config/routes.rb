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
  resources :collected_shifts, except: [:show, :new]
  resources :created_shifts, only: [:index, :create, :destroy]
end
