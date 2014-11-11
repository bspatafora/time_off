require 'rails_helper'

describe HomeController, :type => :controller do
  context 'when user is logged in' do
    it 'sets @token to the user’s token' do
      session[:token] = 'token'

      get :index
      expect(assigns(:token)).to eq('token')
    end
  end

  context 'when user is not logged in' do
    it 'redirects to the authorization URL' do
      get :index
      expect(response).to redirect_to('/auth/google_oauth2')
    end
  end
end
