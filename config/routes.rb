Rails.application.routes.draw do
  root 'home#index', as: 'home'
  get '/auth/:provider/callback' => 'sessions#create'
end
