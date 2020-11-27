Rails.application.routes.draw do
  devise_for :users

  # Generates tweets paths
  resources :tweets do
    resources :likes
    resources :retweets
  end

  resources :follows, only: [:create, :destroy]

  resources :users do
    member do
      get :following, :followers
    end
    resources :messages
  end

  get 'tweets/index'

  # This redirects user to tweets index after succesful login
  get '/user' => "tweets#index", :as => :user_root

  get '/search' => 'users#search', :as => 'search_user'
  
  get 'home/index'
  
  root "home#index"

  match 'users/:id' => 'users#show', via: :get
end