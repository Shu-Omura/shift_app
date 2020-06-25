Rails.application.routes.draw do
  root 'statics#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  resources :users, only: [:show, :index]
end
