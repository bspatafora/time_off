class HomeController < ApplicationController
  def index
    if session[:token]
      @token = session[:token]
    else
      redirect_to '/auth/google_oauth2'
    end
  end
end
