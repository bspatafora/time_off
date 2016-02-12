require 'calendar_service/mock'
require 'factory'
require 'interactor/day_off'
require 'memory_repository/day_off_repository'
require 'memory_repository/user_repository'
require 'presenter/days_off'
require 'rails_helper'
require 'token_service/mock'

describe DaysOffController, :type => :controller do
  before(:each) do
    Service.register(
      day_off_repository: MemoryRepository::DayOffRepository.new,
      user_repository: MemoryRepository::UserRepository.new,
      calendar: CalendarService::Mock.new,
      token: TokenService::Mock.new
    )
  end

  describe 'days off index' do
    it 'returns the user’s days off' do
      user = Service.for(:user_repository).save(Factory.user)
      day_off = Service.for(:day_off_repository).save(Factory.day_off(user_id: user.id))
      session[:user_id] = user.id

      get :index

      days_off = assigns(:days_off).list
      expect(days_off.count).to eq(1)
      expect(days_off.first).to eq(day_off)
    end

    it 'renders the index' do
      user = Service.for(:user_repository).save(Factory.user)
      session[:user_id] = user.id

      get :index

      expect(response).to render_template(:index)
    end

    context 'when no user is signed in' do
      it 'redirects to the sign in page' do
        get :index

        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end

  describe 'day off creation' do
    it 'adds the day off to the repository and the calendar service' do
      user = Service.for(:user_repository).save(Factory.user)
      day_off = Factory.day_off(user_id: user.id)
      session[:user_id] = user.id

      post :create,
        date: day_off.date,
        range: day_off.range.description,
        category: day_off.category

      retrieved_day_off = Service.for(:day_off_repository).find_by_user_id(user.id).first
      expect(retrieved_day_off.date).to eq(day_off.date)
      expect(retrieved_day_off.range.description).to eq(day_off.range.description)
      expect(retrieved_day_off.category).to eq(day_off.category)
      expect(Service.for(:calendar).added_events.count).to eq(1)
    end

    it 'stores a range of all_day when passed a day-length of full_day' do
      user = Service.for(:user_repository).save(Factory.user)
      day_off = Factory.day_off(user_id: user.id)
      session[:user_id] = user.id

      post :create,
        date: day_off.date,
        range: day_off.range,
        'day-length' => 'full_day',
        category: day_off.category

      retrieved_day_off = Service.for(:day_off_repository).find_by_user_id(user.id).first
      expect(retrieved_day_off.range.description).to eq('all_day')
    end

    context 'when no user is signed in' do
      it 'redirects to the sign in page' do
        post :create

        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end

  describe 'destroying a day off' do
    it 'removes the day off from the repository and the calendar service' do
      user = Service.for(:user_repository).save(Factory.user)
      day_off = Service.for(:day_off_repository).save(Factory.day_off(user_id: user.id))
      session[:user_id] = user.id

      delete :destroy, id: day_off.id

      expect(Service.for(:day_off_repository).find_by_user_id(user.id).count).to eq(0)
    end

    context 'when no user is signed in' do
      it 'redirects to the sign in page' do
        delete :destroy

        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end
end
