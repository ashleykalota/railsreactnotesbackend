Rails.application.routes.draw do
  
  resources :notes
  resource :users, only: [:create]
  resources :ambulance_requests, only: [:index, :update]  # Only allow index and update for authorized users
  resources :drivers, only: [:index, :show, :create, :update, :destroy]
  resources :billings, only: [:create, :show]
  
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
 
  # New location routes
  get "/google_maps_key", to: "locations#google_maps_key"
  get "locations/directions", to: "locations#directions"
  get "locations/distance_matrix", to: "locations#distance_matrix"
  post "/ambulance_requests", to: "ambulance_requests#create_request" # Allow guests to create requests
  post "/billings/calculate_price", to: "billings#calculate_price"

end
