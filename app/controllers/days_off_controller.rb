require 'service'
require 'repository_object/day_off'
require 'presenter/days_off'

class DaysOffController < ApplicationController
  before_filter :authenticate_user!

  def index
    @email = session[:email]
    @days_off = Presenter::DaysOff.new(Service.for(:day_off_repository).find_by_email(@email))
  end

  def create
    day_off = RepositoryObject::DayOff.new(
      email: session[:email],
      date: params[:date],
      category: params[:category])
    day_off.url = Service.for(:calendar).add_event(day_off)
    Service.for(:day_off_repository).save(day_off)
    redirect_to home_path
  end

  private

  def authenticate_user!
    redirect_to '/auth/google_oauth2' if !session[:email]
  end
end
