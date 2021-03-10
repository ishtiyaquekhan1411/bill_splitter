Rails.application.routes.draw do

  root 'pages#home'
  get 'about', to: 'pages#about'

  resources :groups, except: %i[edit update] do
    resources :memberships, only: %i[new create destroy]
    resources :bills, only: %i[new create]
  end
  get 'activities', to: 'bills#index'
  namespace :users do
	  get 'signup', to: 'registrations#new'
    post 'signup', to: 'registrations#create'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

end
