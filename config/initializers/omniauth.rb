Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['TIME_OFF_CLIENT_ID'], ENV['TIME_OFF_CLIENT_SECRET']
end
