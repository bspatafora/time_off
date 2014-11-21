Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.config.client_id,
           Rails.application.config.client_secret,
           { scope: 'calendar,email' }
end
