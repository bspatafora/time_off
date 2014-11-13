require 'rails_helper'

describe HomeController, :type => :controller do
  context 'when user is logged in' do
    it 'sets @email to the user’s email' do
      session[:email] = 'email'

      get :index
      expect(assigns(:email)).to eq('email')
    end
  end

  context 'when user is not logged in' do
    it 'redirects to the authorization URL' do
      get :index
      expect(response).to redirect_to('/auth/google_oauth2')
    end
  end
end
