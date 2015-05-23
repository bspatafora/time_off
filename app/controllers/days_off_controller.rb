require 'interactor/day_off'
require 'presenter/days_off'

class DaysOffController < ApplicationController
  before_filter :authenticate_user!

  def index
    @days_off = Presenter::DaysOff.new(Interactor::DayOff.all_for(session[:user_id]))
  end

  def create
    Interactor::DayOff.create(
      user_id: session[:user_id],
      date: params[:date],
      range: range(params),
      category: params[:category])
    redirect_to days_off_path
  end

  def destroy
    Interactor::DayOff.destroy(params[:id].to_i)
    redirect_to days_off_path
  end

  private

  def authenticate_user!
    redirect_to '/auth/google_oauth2' if !session[:user_id]
  end

  def range(params)
    return 'all_day' if params['day-length'] == 'full_day'
    params[:range]
  end
end
