Rails.application.routes.draw do
  apipie
  resources :users
  resources :tags, as: 'acts_as_taggable_on_tag'
  resource :session, only: [:new, :create, :destroy]

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        get '/sign_in', to: 'sessions#create', constraints: { format: :json }
        get '/sign_out', to: 'sessions#destroy', constraints: { format: :json }
        get '/omniauth/:provider/callback', to: 'omniauth_callbacks#callback', as: 'omniauth_callback'
        get '/omniauth/failure', to: 'omniauth_callbacks#failure', as: 'omniauth_failure'
      end

      resources :users, only: [:index, :show, :create, :update], constraints: { format: /(json)/ }
      get 'unify/:id', controller: :users, action: :unify, as: :unify, constraints: { format: /(json)/ }
    end

    namespace :v0 do
      resources :ping, only: [:index], constraints: { format: /(json)/ }
    end

  end
  root to: 'application#welcome'
end
