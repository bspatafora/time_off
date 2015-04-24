require 'interactor/day_off'
require 'presenter/days_off'
require 'rails_helper'

describe DaysOffController, :type => :controller do
  describe '#index' do
    context 'when user is logged in' do
      it 'sets @days_off, then renders index' do
        email = 'user@email.com'
        session[:email] = email
        allow(Interactor::DayOff).to receive(:all_for)

        get :index
        expect(Interactor::DayOff).to have_received(:all_for).with(email)
        expect(assigns(:days_off)).to be_a(Presenter::DaysOff)
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the authentication URL' do
        get :index
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end

  describe '#create' do
    context 'when user is logged in' do
      before do
        @email = 'user@email.com'
        @date = '2014-12-04'
        @range = 'morning'
        @category = 'Vacation'
        session[:email] = @email
      end

      it 'starts off creation of a day off with the passed parameters, then redirects to the day off URL' do
        allow(Interactor::DayOff).to receive(:create)

        post :create,
          email: @email,
          date: @date,
          range: @range,
          category: @category
        expect(Interactor::DayOff).to have_received(:create).with(
          email: @email,
          date: @date,
          range: @range,
          category: @category)
        expect(response).to redirect_to(days_off_path)
      end

      it 'passes the interactor a range of “all_day” if the `day-length` param has a value of “full_day”' do
        allow(Interactor::DayOff).to receive(:create)

        post :create,
          email: @email,
          date: @date,
          'day-length' => 'full_day',
          range: @range,
          category: @category
        expect(Interactor::DayOff).to have_received(:create).with(
          email: @email,
          date: @date,
          range: 'all_day',
          category: @category)
        expect(response).to redirect_to(days_off_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the authentication URL' do
        post :create
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged in' do
      it 'starts off destruction of the day off with the specified ID, then redirects to the day off URL' do
        email, event_id = 'user@email.com', '3v3n71d'
        session[:email] = email
        allow(Interactor::DayOff).to receive(:destroy)

        delete :destroy, event_id: event_id
        expect(Interactor::DayOff).to have_received(:destroy).with(event_id, email)
        expect(response).to redirect_to(days_off_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the authentication URL' do
        delete :destroy
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end
end
