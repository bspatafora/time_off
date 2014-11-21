require 'repository_object/user'

shared_examples 'a user repository' do
  describe '#save and #find_by_email' do
    it 'saves users and finds them by email' do
      user_repository = described_class.new
      email, refresh_token, token, token_expiration = 'user@email.com', '70k3n', '70k3n', 1234567890

      user = RepositoryObject::User.new(
        email: email,
        refresh_token: refresh_token,
        token: token,
        token_expiration: token_expiration)
      user_repository.save(user)
      retrieved_user = user_repository.find_by_email(email)
      expect(retrieved_user.email).to eq(email)
      expect(retrieved_user.refresh_token).to eq(refresh_token)
      expect(retrieved_user.token).to eq(token)
      expect(retrieved_user.token_expiration).to eq(token_expiration)
    end
  end
end
