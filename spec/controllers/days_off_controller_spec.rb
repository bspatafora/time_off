require 'rails_helper'

require 'calendar_service/mock'
require 'memory_repository/day_off_repository'
require 'memory_repository/user_repository'
require 'repository_object/day_off'
require 'token_service/mock'
require 'service'

describe DaysOffController, :type => :controller do
  before(:each) do
    Service.register(:day_off_repository, MemoryRepository::DayOffRepository.new)
    Service.register(:user_repository, MemoryRepository::UserRepository.new)
    Service.register(:calendar, CalendarService::Mock.new)
    Service.register(:token, TokenService::Mock.new)
  end

  describe '#index' do
    context 'when user is logged in' do
      before do
        @email = 'user@email.com'
        session[:email] = @email

        @day_off = RepositoryObject::DayOff.new(email: @email)
        Service.for(:day_off_repository).save(@day_off)
      end

      it 'sets @email and @days_off' do
        get :index
        expect(assigns(:email)).to eq(@email)
        expect(assigns(:days_off).list[0]).to eq(@day_off)
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the authorization URL' do
        get :index
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end

  describe '#create' do
    context 'when user is logged in' do
      before do
        @email = 'user@email.com'
        @date = '2014-11-14'
        @category = 'Vacation'

        user = RepositoryObject::User.new(email: @email)
        Service.for(:user_repository).save(user)
      end

      it 'adds the day off to the calendar service and the repository, then redirects to the days off path' do
        session[:email] = @email

        post :create, email: @email, date: @date, category: @category
        day_off = Service.for(:day_off_repository).find_by_email(@email)[0]
        expect(day_off.date).to eq(@date)
        expect(day_off.category).to eq(@category)
        expect(day_off.url).to eq(Service.for(:calendar).url)
        expect(response).to redirect_to(days_off_path)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the authorization URL' do
        post :create, email: '', date: '', category: ''
        expect(response).to redirect_to('/auth/google_oauth2')
      end
    end
  end
end
