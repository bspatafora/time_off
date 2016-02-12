require 'service'
require 'repository_object/user'

class SessionsController < ApplicationController
  def create
    authentication = request.env['omniauth.auth']
    user = RepositoryObject::User.new(
      email: authentication[:info][:email],
      token: authentication[:credentials][:token],
      token_expiration: authentication[:credentials][:expires_at],
      refresh_token: authentication[:credentials][:refresh_token]
    )

    user = Service.for(:user_repository).save(user)
    session[:user_id] = user.id
    redirect_to days_off_path
  end
end
