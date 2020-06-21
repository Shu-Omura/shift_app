Rails.application.routes.draw do
  root 'statics#top'
  resources :users, only: [:show, :index]
end
