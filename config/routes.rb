Rails.application.routes.draw do
  get 'collected_shifts/index'
  get 'collected_shifts/show'
  get 'collected_shifts/new'
  get 'collected_shifts/edit'
  root 'statics#top'
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  resources :users, only: [:show, :index]
end
