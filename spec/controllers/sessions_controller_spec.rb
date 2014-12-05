require 'rails_helper'

require 'memory_repository/user_repository'
require 'repository_object/user'
require 'service'

describe SessionsController, :type => :controller do
  before do
    Service.register(:user_repository, MemoryRepository::UserRepository.new)
    @email, @token, @token_expiration = 'user@email.com', '70k3n', '3600'
    @auth_hash = {
      info: { email: @email },
      credentials: { token: @token, expires_at: @token_expiration }
    }
  end

  describe '#create' do
    context 'when a user has previously granted consent' do
      before do
        existing_user = RepositoryObject::User.new(email: @email)
        Service.for(:user_repository).save(existing_user)
        request.env['omniauth.auth'] = @auth_hash
      end

      it 'stores the user’s email in the session, and token and token expiration in the repository, then redirects to the days off path' do
        post :create, :provider => 'provider'
        user = Service.for(:user_repository).find_by_email(@email)
        expect(session[:email]).to eq(@email)
        expect(user.token).to eq(@token)
        expect(user.token_expiration).to eq(@token_expiration)
        expect(response).to redirect_to(days_off_path)
      end
    end

    context 'when a user grants consent for the first time' do
      before do
        @refresh_token = '70k3n'
        auth_hash_with_refresh = @auth_hash.dup
        auth_hash_with_refresh[:credentials][:refresh_token] = @refresh_token
        request.env['omniauth.auth'] = auth_hash_with_refresh
      end

      it 'stores the user’s email and refresh token in the repository' do
        post :create, :provider => 'provider'
        user = Service.for(:user_repository).find_by_email(@email)
        expect(user.refresh_token).to eq(@refresh_token)
      end
    end
  end
end
