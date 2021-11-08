Rails.application.routes.draw do

  get 'likes/index'
  get 'likes/show'
  get 'likes/new'
  get 'likes/create'
  get 'likes/destroy'
  # Specify what Rails should route '/'. The root route only routes GET requests to the action > https://edgeguides.rubyonrails.org/routing.html
  root 'home#show' #idem que root to: 'home#index'

  # routes dont le controller ne manipule pas de données en base (pas besoin de méthodes CRUD)
  get 'home', to: 'home#show'
  get 'welcome/:user_first_name', to: 'welcome#show'
  get 'team', to: 'team#show'
  get 'contact', to: 'contact#show'

  # routes dont le controller manipule des données en base ou des données temporaires (via méthodes CRUD)
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]
  resources :gossips do 
    resources :comments, except: [:index, :show]
    resources :likes, only: [:new, :create, :destroy]
  end
  resources :cities
  resources :profile, only: [:show, :edit, :update, :destroy]
  
end

# NB : Rails routes are matched in the order they are specified > https://edgeguides.rubyonrails.org/routing.html
