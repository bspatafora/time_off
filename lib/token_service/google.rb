require 'json'
require 'net/http'

module TokenService
  class Google
    def self.refresh(refresh_token)
      response = Net::HTTP.post_form(uri, body(refresh_token))
      data = JSON.parse(response.body)
      OpenStruct.new(
        token: data['access_token'],
        token_expiration: expires_at(data['expires_in']))
    end

    private

    def self.uri
      URI('https://accounts.google.com/o/oauth2/token')
    end

    def self.body(refresh_token)
      { 'refresh_token' => refresh_token,
        'client_id' => Rails.application.config.client_id,
        'client_secret' => Rails.application.config.client_secret,
        'grant_type' => 'refresh_token' }
    end

    def self.expires_at(seconds_from_now)
      Time.now.to_i + seconds_from_now.to_i
    end
  end
end
