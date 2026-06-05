Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#index"
  get "signup", to: "users#new"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  resources :users, only: %i[create show]
  resources :recipes, only: %i[index show] do
    resource :favorite, only: %i[create destroy], controller: :recipe_favorites
  end

  namespace :account do
    root "profiles#show"
    resource :profile, only: :show
    resources :recipes, except: :show
    resources :favorites, only: :index
  end

  namespace :api, defaults: { format: :json } do
    resources :recipes
  end

  namespace :admin do
    root "dashboard#index"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :categories, except: :show
    resources :ingredients, except: :show
    resources :recipes, except: :show do
      member do
        patch :publish
        patch :unpublish
      end
    end
  end
end
