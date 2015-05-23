require 'calendar_service/mock'
require 'interactor/day_off'
require 'factory'
require 'memory_repository/day_off_repository'
require 'memory_repository/user_repository'
require 'service'
require 'time_range'
require 'token_service/mock'

describe Interactor::DayOff do
  before(:each) do
    Service.register(
      day_off_repository: MemoryRepository::DayOffRepository.new,
      user_repository: MemoryRepository::UserRepository.new,
      calendar: CalendarService::Mock.new,
      token: TokenService::Mock.new
    )
  end

  it 'retrieves a user’s days off' do
    day_off = Factory.day_off(user_id: 1)
    Service.for(:day_off_repository).save(day_off)

    expect(described_class.all_for(1)).to eq([day_off])
  end

  describe 'creating a day off' do
    it 'adds it to the repository' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email(user.email)

      described_class.create(
        user_id: user.id,
        date: '2015-05-23',
        range: 'all_day',
        category: 'Vacation'
      )

      day_off = Service.for(:day_off_repository).find_by_user_id(user.id).first
      expect(day_off.date).to eq('2015-05-23')
      expect(day_off.range.description).to eq('all_day')
      expect(day_off.category).to eq('Vacation')
    end

    it 'adds it to the calendar service and saves the event ID and URL from the response' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email(user.email)

      described_class.create(
        user_id: user.id,
        date: '2015-05-23',
        range: 'all_day',
        category: 'Vacation'
      )

      day_off = Service.for(:day_off_repository).find_by_user_id(user.id).first
      expect(day_off.event_id).to eq(Service.for(:calendar).event_id)
      expect(day_off.url).to eq(Service.for(:calendar).url)
    end

    it 'refreshes the user’s token if it’s expired' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email(user.email)

      described_class.create(
        user_id: user.id,
        date: '2015-05-23',
        range: 'all_day',
        category: 'Vacation'
      )

      expect(user.token).to eq(Service.for(:token).token)
      expect(user.token_expiration).to eq(Service.for(:token).token_expiration)
    end
  end

  describe 'destroying a day off' do
    it 'removes the day off from the day off repository' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email('user@email.com')

      day_off = Factory.day_off(user_id: user.id)
      Service.for(:day_off_repository).save(day_off)
      Service.for(:day_off_repository).find_by_user_id(day_off.user_id)

      Interactor::DayOff.destroy(day_off.id)

      days_off_for_user = Service.for(:day_off_repository).find_by_user_id(day_off.user_id)
      expect(days_off_for_user.count).to eq(0)
    end

    it 'removes the day off from the calendar service' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email('user@email.com')

      day_off = Factory.day_off(user_id: user.id)
      Service.for(:day_off_repository).save(day_off)
      Service.for(:day_off_repository).find_by_user_id(day_off.user_id)

      Interactor::DayOff.destroy(day_off.id)
      expect(Service.for(:calendar).destroyed_events).to include(day_off.event_id)
    end

    it 'updates the user’s token data if needed' do
      user = Factory.user
      Service.for(:user_repository).save(user)
      user = Service.for(:user_repository).find_by_email('user@email.com')

      day_off = Factory.day_off(user_id: user.id)
      Service.for(:day_off_repository).save(day_off)
      Service.for(:day_off_repository).find_by_user_id(day_off.user_id)

      Interactor::DayOff.destroy(day_off.id)
      user = Service.for(:user_repository).find(day_off.user_id)
      expect(user.token).to eq(Service.for(:token).token)
      expect(user.token_expiration).to eq(Service.for(:token).token_expiration)
    end
  end
end
