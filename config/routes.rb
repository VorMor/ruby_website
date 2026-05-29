Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#index"
  resources :recipes, only: %i[index show]

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
