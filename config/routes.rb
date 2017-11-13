Rails.application.routes.draw do
  resources :ratings, only: [:update]
  resources :categories
  resources :quotes
  resources :viewed_quotes, only: [:index] do
    get 'filter/:name' => 'viewed_quotes#filter', on: :collection
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:index, :show, :update]

  get 'home/index'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
