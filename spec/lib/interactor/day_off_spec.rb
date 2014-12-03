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
      @email = 'user@email.com'
      @date = '2014-12-02'
      @category = 'Holiday'

      user = RepositoryObject::User.new(email: @email)
      Service.for(:user_repository).save(user)
    end

    it 'adds the day off to the day off repository' do
      Interactor::DayOff.create(email: @email, date: @date, category: @category)

      day_off = Service.for(:day_off_repository).find_by_email(@email)[0]
      expect(day_off.email).to eq(@email)
      expect(day_off.date).to eq(@date)
      expect(day_off.category).to eq(@category)
    end

    it 'adds the day off to the calendar service, persisting the returned URL' do
      Interactor::DayOff.create(email: @email, date: @date, category: @category)

      day_off = Service.for(:day_off_repository).find_by_email(@email)[0]
      expect(day_off.url).to eq(Service.for(:calendar).url)
    end
  end
end
