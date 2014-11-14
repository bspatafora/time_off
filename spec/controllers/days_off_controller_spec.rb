require 'rails_helper'

describe DaysOffController, :type => :controller do
  before do
    @day_off = MemoryRepository::DayOff
    Repository.register(:days_off, MemoryRepository::DayOffRepository.new)
  end

  describe '#index' do
    context 'when user is logged in' do
      it 'sets @email and @days_off' do
        email = 'email'
        session[:email] = email
        days_off_repository = Repository.for(:days_off)
        day_off = @day_off.new(email: email,
                               date: '2014-11-14',
                               category: 'category')
        days_off_repository.save(day_off)
        days_off = days_off_repository.find_by_email(email)

        get :index
        expect(assigns(:email)).to eq(email)
        expect(assigns(:days_off)).to eq(days_off)
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
    it 'adds the day off to the signed in user’s days off and redirects to home' do
      email, date, category = 'email', '2014-11-14', 'category'

      post :create, email: email, date: date, category: category
      day_off = Repository.for(:days_off).find_by_email(email).first
      expect(day_off.date).to eq(date)
      expect(day_off.category).to eq(category)
      expect(response).to redirect_to(home_path)
    end
  end
end
