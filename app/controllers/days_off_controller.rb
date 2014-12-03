require 'interactor/day_off'
require 'presenter/days_off'

class DaysOffController < ApplicationController
  before_filter :authenticate_user!

  def index
    @email = session[:email]
    @days_off = Presenter::DaysOff.new(Interactor::DayOff.all_for(@email))
  end

  def create
    Interactor::DayOff.create(
      email: session[:email],
      date: params[:date],
      category: params[:category])
    redirect_to days_off_path
  end

  private

  def authenticate_user!
    redirect_to '/auth/google_oauth2' if !session[:email]
  end
end
