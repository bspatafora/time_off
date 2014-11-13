require 'memory_repository/user'
require 'repository'

class SessionsController < ApplicationController
  layout false
 
  def create
    authorization = request.env['omniauth.auth']
    email = authorization[:info][:email]
    token = authorization[:credentials][:token]
    token_expiration = authorization[:credentials][:expires_at]

    session[:email] = email
    session[:token] = token
    session[:token_expiration] = token_expiration

    if authorization[:credentials].has_key? :refresh_token
      user = MemoryRepository::User.new({ email: email,
                                          refresh_token: authorization[:credentials][:refresh_token] })
      Repository.for(:user).save(user)
    end

    redirect_to home_path
  end
end
