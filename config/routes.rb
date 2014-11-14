Rails.application.routes.draw do
  root 'days_off#index', as: 'home'
  get '/auth/:provider/callback' => 'sessions#create'
  post '/' => 'days_off#create'
end
