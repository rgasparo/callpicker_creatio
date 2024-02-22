Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "main#index"
  root 'phones#index'
  get 'lead_action', to: 'lead#lead_action'
  # get '/search', to: 'lead#search', as: :search_lead

  # post '/search', to: 'leads#search' 'search'
  # post '/', to: 'leads#buscar_lead'
  # get '/', to: 'leads#buscar_lead'
end
