require 'repository_object/user'
require 'repository_object/day_off'
require 'time_range'

shared_examples 'a day off repository' do
  before do
    @day_off = RepositoryObject::DayOff
  end

  def user_repository
    repository_name = described_class.name.split('::').first
    eval(repository_name)::UserRepository.new
  end

  describe '#save and #find_by_email' do
    before(:each) do
      @day_off_repository = described_class.new
      @user = RepositoryObject::User.new(email: 'user@email.com')
      user_repository.save(@user)

      @date = '2014-11-14'
      @range = TimeRange.new(description: TimeRange::ALL_DAY)
      @category = 'Holiday'
      @event_id = '3v3n71d'
      @url = 'event/url'
    end

    it 'saves days off and returns a user’s days off' do
      day_off = RepositoryObject::DayOff.new(
        email: @user.email,
        date: @date,
        range: @range,
        category: @category,
        event_id: @event_id,
        url: @url)
      @day_off_repository.save(day_off)

      retrieved_day_off = @day_off_repository.find_by_email(@user.email).first
      expect(retrieved_day_off.date).to eq(@date)
      expect(retrieved_day_off.range.description).to eq(@range.description)
      expect(retrieved_day_off.category).to eq(@category)
      expect(retrieved_day_off.event_id).to eq(@event_id)
      expect(retrieved_day_off.url).to eq(@url)
    end

    it 'returns all of a user’s days off' do
      day_off = RepositoryObject::DayOff.new(
        email: @user.email,
        date: @date,
        range: @range,
        category: @category,
        url: @url)
      @day_off_repository.save(day_off)
      @day_off_repository.save(day_off)

      retrieved_days_off = @day_off_repository.find_by_email(@user.email)
      expect(retrieved_days_off.count).to eq(2)
    end
  end

  describe '#destroy_by_event_id' do
    before do
      @day_off_repository = described_class.new
      @user = RepositoryObject::User.new(email: 'user@email.com')
      user_repository.save(@user)
    end

    it 'destroys the day off with the specified event id' do
      email, event_id = 'user@email.com', '3v3n71d'
      day_off = RepositoryObject::DayOff.new(
        email: @user.email,
        event_id: event_id,
        range: TimeRange.new(description: TimeRange::ALL_DAY))
      @day_off_repository.save(day_off)

      @day_off_repository.destroy_by_event_id(event_id)
      days_off_for_user = @day_off_repository.find_by_email(@user.email)
      expect(days_off_for_user.count).to eq(0)
    end
  end
end
