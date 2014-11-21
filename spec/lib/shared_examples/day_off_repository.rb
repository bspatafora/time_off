require 'repository_object/user'
require 'repository_object/day_off'

shared_examples 'a day off repository' do
  before do
    @day_off = RepositoryObject::DayOff
  end

  def user_repository
    repository_name = described_class.name.split('::').first
    eval(repository_name)::UserRepository.new
  end

  describe '#save and #find_by_user' do
    before(:each) do
      @day_off_repository = described_class.new
      @user = RepositoryObject::User.new(email: 'user@email.com')
      user_repository.save(@user)
      @date, @category, @url = '2014-11-14', 'Holiday', 'day_off/link'
    end

    it 'saves days off and returns a user’s days off' do
      day_off = RepositoryObject::DayOff.new(
        email: @user.email,
        date: @date,
        category: @category,
        url: @url)
      @day_off_repository.save(day_off)

      retrieved_day_off = @day_off_repository.find_by_email(@user.email).first
      expect(retrieved_day_off.date).to eq(@date)
      expect(retrieved_day_off.category).to eq(@category)
      expect(retrieved_day_off.url).to eq(@url)
    end

    it 'returns all of a user’s days off' do
      day_off = RepositoryObject::DayOff.new(
        email: @user.email,
        date: @date,
        category: @category,
        url: @url)
      @day_off_repository.save(day_off)
      @day_off_repository.save(day_off)

      retrieved_days_off = @day_off_repository.find_by_email(@user.email)
      expect(retrieved_days_off.count).to eq(2)
    end
  end
end
