require 'interactor/day_off'
require 'presenter/days_off'
require 'presenter/remaining_count'
require 'service'

class DaysOffController < ApplicationController
  before_filter :authenticate_user!

  def index
    default_flex_days_remaining_in_2014 = 0
    days_off = Interactor::DayOff.all_for(session[:email])
    @days_off = Presenter::DaysOff.new(days_off)
    @remaining_count = Presenter::RemainingCount.new(
      days_off,
      default_flex_days_remaining_in_2014)
  end

  def create
    Interactor::DayOff.create(
      email: session[:email],
      date: params[:date],
      range: range(params),
      category: params[:category])
    redirect_to days_off_path
  end

  def destroy
    Interactor::DayOff.destroy(
      params[:event_id],
      session[:email])
    redirect_to days_off_path
  end

  private

  def authenticate_user!
    redirect_to '/auth/google_oauth2' if !session[:email]
  end

  def range(params)
    return 'all_day' if params['day-length'] == 'full_day'
    params[:range]
  end
end
