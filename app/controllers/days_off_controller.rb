require 'memory_repository/day_off'
require 'repository'

class DaysOffController < ApplicationController
  def index
    if session[:email]
      @email = session[:email]
      @days_off = Repository.for(:days_off).find_by_email(@email)
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def create
    day_off = MemoryRepository::DayOff.new(email: params[:email],
                                           date: params[:date],
                                           category: params[:category])
    Repository.for(:days_off).save(day_off)
    redirect_to home_path
  end
end
