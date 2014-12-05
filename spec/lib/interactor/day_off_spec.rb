require 'calendar_service/mock'
require 'interactor/day_off'
require 'memory_repository/day_off_repository'
require 'memory_repository/user_repository'
require 'repository_object/day_off'
require 'service'
require 'token_service/mock'

describe Interactor::DayOff do
  before(:each) do
    Service.register(:day_off_repository, MemoryRepository::DayOffRepository.new)
    Service.register(:user_repository, MemoryRepository::UserRepository.new)
    Service.register(:calendar, CalendarService::Mock.new)
    Service.register(:token, TokenService::Mock.new)
  end

  describe '#all_for' do
    it 'returns the user’s days off' do
      email = 'user@email.com'
      day_off = RepositoryObject::DayOff.new(email: email)
      Service.for(:day_off_repository).save(day_off)
      days_off_for_user = [day_off]

      expect(Interactor::DayOff.all_for(email)).to eq(days_off_for_user)
    end
  end

  describe '#create' do
    before(:each) do
      @email, @date, @category = 'user@email.com', '2014-12-02', 'Holiday'
      expired = 946684800

      user = RepositoryObject::User.new(
        email: @email,
        token_expiration: expired)
      Service.for(:user_repository).save(user)
    end

    it 'adds the day off to the day off repository' do
      Interactor::DayOff.create(email: @email, date: @date, category: @category)
      day_off = Service.for(:day_off_repository).find_by_email(@email)[0]
      expect(day_off.email).to eq(@email)
      expect(day_off.date).to eq(@date)
      expect(day_off.category).to eq(@category)
    end

    it 'adds the day off to the calendar service, persisting the returned ID and URL' do
      Interactor::DayOff.create(email: @email, date: @date, category: @category)
      day_off = Service.for(:day_off_repository).find_by_email(@email)[0]
      expect(day_off.event_id).to eq(Service.for(:calendar).event_id)
      expect(day_off.url).to eq(Service.for(:calendar).url)
    end

    it 'updates the user’s token data if needed' do
      Interactor::DayOff.create(email: @email, date: @date, category: @category)
      user = Service.for(:user_repository).find_by_email(@email)
      expect(user.token).to eq(Service.for(:token).token)
      expect(user.token_expiration).to eq(Service.for(:token).token_expiration)
    end
  end

  describe '#destroy' do
    before(:each) do
      @email, @event_id = 'user@email.com', '3v3n71d'
      expired = 946684800

      user = RepositoryObject::User.new(
        email: @email,
        token_expiration: expired)
      Service.for(:user_repository).save(user)
    end

    it 'removes the day off from the day off repository' do
      day_off = RepositoryObject::DayOff.new(email: @email, event_id: @event_id)
      Service.for(:day_off_repository).save(day_off)

      Interactor::DayOff.destroy(@event_id, @email)
      days_off_for_user = Service.for(:day_off_repository).find_by_email(@email)
      expect(days_off_for_user.count).to eq(0)
    end

    it 'removes the day off from the calendar service' do
      Interactor::DayOff.destroy(@event_id, @email)
      expect(Service.for(:calendar).destroyed_events).to include(@event_id)
    end

    it 'updates the user’s token data if needed' do
      Interactor::DayOff.destroy(@event_id, @email)
      user = Service.for(:user_repository).find_by_email(@email)
      expect(user.token).to eq(Service.for(:token).token)
      expect(user.token_expiration).to eq(Service.for(:token).token_expiration)
    end
  end
end
