require 'memory_repository/user'

shared_examples 'a user repository' do
  describe '#save and #find_by_email' do
    it 'saves users and finds them by email' do
      user_repository = described_class.new
      email, refresh_token = 'test@email.com', 'refresh_token'

      user_repository.save(MemoryRepository::User.new(email: email, refresh_token: refresh_token))
      user = user_repository.find_by_email('test@email.com')
      expect(user.email).to eq(email)
      expect(user.refresh_token).to eq(refresh_token)
    end
  end
end
