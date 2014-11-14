describe SessionsController, :type => :controller do
  before do
    Repository.register(:user, MemoryRepository::UserRepository.new)
    @email, @token, @token_expiration = 'email', 'token', 'token_expiration'
    @authorization = {
      info: { email: @email },
      credentials: { token: @token, expires_at: @token_expiration }
    }
  end

  describe '#create' do
    it 'stores the email, token, and token expiration in the user’s session' do
      request.env['omniauth.auth'] = @authorization

      post :create, :provider => 'provider'
      expect(session[:email]).to eq(@email)
      expect(session[:token]).to eq(@token)
      expect(session[:token_expiration]).to eq(@token_expiration)
    end

    it 'redirects to home' do
      request.env['omniauth.auth'] = @authorization

      post :create, :provider => 'provider'
      expect(response).to redirect_to(home_path)
    end

    context 'when a user grants consent for the first time' do
      it 'stores the email and refresh token in a repository' do
        refresh_token = 'refresh_token'
        authorization_with_refresh = @authorization.dup
        authorization_with_refresh[:credentials][:refresh_token] = refresh_token
        request.env['omniauth.auth'] = authorization_with_refresh

        post :create, :provider => 'provider'
        stored_user = Repository.for(:user).find_by_email('email')
        expect(stored_user.refresh_token).to eq(refresh_token)
      end
    end
  end
end
