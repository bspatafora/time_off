require 'service'
require 'repository_object/day_off'
require 'presenter/days_off'

class DaysOffController < ApplicationController
  def index
    if session[:email]
      @email = session[:email]
      days_off = Service.for(:day_off_repository).find_by_email(@email)
      @days_off = Presenter::DaysOff.new(days_off)
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def create
    day_off = RepositoryObject::DayOff.new(email: params[:email],
                                           date: params[:date],
                                           category: params[:category])
    day_off.url = Service.for(:calendar).addEvent(day_off)
    Service.for(:day_off_repository).save(day_off)
    redirect_to home_path
  end
end
