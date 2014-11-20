require 'service'
require 'repository_object/user'

class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']

    user = RepositoryObject::User.new(
      email: auth_hash[:info][:email],
      token: auth_hash[:credentials][:token],
      token_expiration: auth_hash[:credentials][:expires_at],
      refresh_token: auth_hash[:credentials][:refresh_token])
    Service.for(:user_repository).save(user)

    session[:email] = auth_hash[:info][:email]

    redirect_to home_path
  end
end
