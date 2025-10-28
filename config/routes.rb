Rails.application.routes.draw do
  # Root path - página principal com upload
  root "emails#index"

  # Rotas para upload de e-mails
  resources :emails, only: [:index, :create]

  # Rotas para listagem de customers
  resources :customers, only: [:index, :show]

  # Rotas para visualização de logs
  resources :email_logs, only: [:index, :show]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
