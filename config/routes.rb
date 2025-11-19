Rails.application.routes.draw do
  resources :premia
  get "known_secrets/create"
  get "known_secrets/destroy"
  resources :secrets
  resources :nodes
  resources :teams
  resources :team_invites
  resources :team_linkers
  resources :known_nodes
  resources :known_secrets
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "/home", to: "static#home"
  get "/dashboard", to: "static#dashboard"
  get "/about", to: "static#about"
  get "/style", to: "static#ui_kit"
  get "/checkout", to: "checkout#create"
  get "/premium", to: "premia#premium"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "static#home"
end
