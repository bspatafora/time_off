Rails.application.routes.draw do
  root 'days_off#index', as: 'days_off'
  get '/auth/:provider/callback' => 'sessions#create'
  post '/' => 'days_off#create'

  get '/404' => 'errors#not_found'
  get '/422' => 'errors#unacceptable'
  get '/500' => 'errors#internal_error'
  get '/error' => 'errors#cause_an_internal_error'
end
