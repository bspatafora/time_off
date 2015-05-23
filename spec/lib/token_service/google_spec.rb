require 'http_client/mock'
require 'service'
require 'token_service/google'

describe TokenService::Google do
  before do
    @http_client = HTTPClient::Mock.new
    Service.register(http_client: @http_client)
    @refresh_token = 'r3fr35h70k3n'
  end

  describe '#refresh' do
    it 'makes a URL-encoded POST request with the correct parameters' do
      described_class.refresh(@refresh_token)
      expect(@http_client.received_post_form_uri).to eq(
        URI('https://accounts.google.com/o/oauth2/token'))
      expect(@http_client.received_post_form_params).to eq(
        { 'refresh_token' => @refresh_token,
          'client_id' => Rails.application.config.client_id,
          'client_secret' => Rails.application.config.client_secret,
          'grant_type' => 'refresh_token' })
    end

    it 'returns an object with an access token and Epoch time token expiration' do
      token_data = described_class.refresh(@refresh_token)
      token_expiration_is_reasonable_epoch_time = token_data.token_expiration > 1418145677
      expect(token_data.token).to eq('access_token')
      expect(token_expiration_is_reasonable_epoch_time).to be true
    end
  end
end
