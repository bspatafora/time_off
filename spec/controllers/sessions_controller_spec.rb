require 'factory'
require 'memory_repository/user_repository'
require 'rails_helper'
require 'repository_object/user'
require 'service'

describe SessionsController, :type => :controller do
  before do
    Service.register(user_repository: MemoryRepository::UserRepository.new)
  end

  describe 'creating a session' do
    it 'stores the email in the session' do
      request.env['omniauth.auth'] = {
        info: {email: 'user@email.com'},
        credentials: {token: 'token', expires_at: '3600', refresh_token: 'refresh_token'}
      }

      post :create, :provider => 'provider'

      user = Service.for(:user_repository).find_by_email('user@email.com')
      expect(session[:user_id]).to eq(user.id)
    end

    context 'when a user grants consent for the first time' do
      it 'stores the email, token, token expiration, and refresh token in the repository' do
        request.env['omniauth.auth'] = {
          info: {email: 'user@email.com'},
          credentials: {token: 'token', expires_at: '3600', refresh_token: 'refresh_token'}
        }

        post :create, :provider => 'provider'

        user = Service.for(:user_repository).find_by_email('user@email.com')
        expect(user.token).to eq('token')
        expect(user.token_expiration).to eq('3600')
        expect(user.refresh_token).to eq('refresh_token')
      end
    end

    context 'when a user has previously granted consent' do
      it 'stores the email, token, and token expiration in the repository' do
        user = Service.for(:user_repository).save(Factory.user)
        request.env['omniauth.auth'] = {
          info: {email: user.email},
          credentials: {
            token: 'new_token',
            expires_at: '3600'
          }
        }

        post :create, :provider => 'provider'

        retrieved_user = Service.for(:user_repository).find_by_email(user.email)
        expect(retrieved_user.token).to eq('new_token')
        expect(retrieved_user.token_expiration).to eq('3600')
      end
    end

    it 'redirects to the days off index' do
      request.env['omniauth.auth'] = {
        info: {email: 'user@email.com'},
        credentials: {token: 'token', expires_at: '3600', refresh_token: 'refresh_token'}
      }

      post :create, :provider => 'provider'

      expect(response).to redirect_to(days_off_path)
    end
  end
end
