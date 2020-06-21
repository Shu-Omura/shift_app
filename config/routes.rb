Rails.application.routes.draw do
  root 'statics#top'
  devise_for :users
  resources :users, only: [:show, :index]
end
