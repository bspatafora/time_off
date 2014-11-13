class HomeController < ApplicationController
  def index
    if session[:email]
      @email = session[:email]
    else
      redirect_to '/auth/google_oauth2'
    end
  end
end
