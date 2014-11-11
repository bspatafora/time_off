require 'rails_helper'

describe SessionsController, :type => :controller do
  before do
    request.env['omniauth.auth'] = { 'credentials' => { 'token' => 'token' } }
  end

  describe '#create' do
    it 'stores the token in the user’s session' do
      post :create, :provider => 'provider'
      expect(session[:token]).to eq('token')
    end

    it 'redirects to home' do
      post :create, :provider => 'provider'
      expect(response).to redirect_to(home_path)
    end
  end
end
