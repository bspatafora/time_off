class SessionsController < ApplicationController
  layout false
 
  def create
    session[:token] = request.env['omniauth.auth']['credentials']['token']
    redirect_to home_path
  end
end
