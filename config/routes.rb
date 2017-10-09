Rails.application.routes.draw do

  resources :categories
  resources :quotes
  devise_for :users
  resources :users, only: [:index, :show]

  get 'home/index'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
