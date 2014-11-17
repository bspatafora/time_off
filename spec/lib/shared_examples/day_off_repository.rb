require 'repository_object/user'
require 'repository_object/day_off'

shared_examples 'a day off repository' do
  before do
    @user = RepositoryObject::User
    @day_off = RepositoryObject::DayOff
  end

  def user_repository
    repository_name = described_class.name.split('::').first
    eval(repository_name)::UserRepository.new
  end

  describe '#save and #find_by_user' do
    it 'saves days off and returns a user’s days off' do
      day_off_repository = described_class.new
      user = @user.new(email: 'email', refresh_token: 'token')
      user_repository.save(user)
      date, category = Date.new(2014,11,14), 'category'
      day_off_repository.save(@day_off.new(email: user.email, date: date, category: category))

      day_off = day_off_repository.find_by_email(user.email).first
      expect(day_off.date).to eq(date)
      expect(day_off.category).to eq(category)
    end

    it 'returns all of a user’s days off' do
      day_off_repository = described_class.new
      user = @user.new(email: 'email', refresh_token: 'token')
      user_repository.save(user)
      date, category = Date.new(2014,11,14), 'category'
      day_off_repository.save(@day_off.new(email: user.email, date: date, category: category))
      day_off_repository.save(@day_off.new(email: user.email, date: date, category: category))

      days_off = day_off_repository.find_by_email(user.email)
      expect(days_off.count).to eq(2)
    end
  end
end
