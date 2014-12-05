Rails.application.routes.draw do
  root 'days_off#index', as: 'days_off'
  post '/' => 'days_off#create'
  delete '/' => 'days_off#destroy'
  get '/auth/:provider/callback' => 'sessions#create'

  get '/404' => 'errors#not_found'
  get '/422' => 'errors#unacceptable'
  get '/500' => 'errors#internal_error'
  get '/error' => 'errors#cause_an_internal_error'
end
