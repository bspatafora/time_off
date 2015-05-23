require 'factory'
require 'repository_object/user'

shared_examples 'a user repository' do
  it 'returns a repository object with the stored user data on save' do
    user = Factory.user
    returned_user = described_class.new.save(user)

    expect(returned_user.id).not_to be_nil
    expect(returned_user.email).to eq(user.email)
    expect(returned_user.token).to eq(user.token)
    expect(returned_user.token_expiration).to eq(user.token_expiration)
    expect(returned_user.refresh_token).to eq(user.refresh_token)
  end

  it 'finds by email' do
    user_repository = described_class.new
    user = Factory.user
    user_repository.save(user)

    retrieved_user = user_repository.find_by_email(user.email)
    expect(retrieved_user.id).not_to be_nil
    expect(retrieved_user.token).to eq(user.token)
    expect(retrieved_user.token_expiration).to eq(user.token_expiration)
    expect(retrieved_user.refresh_token).to eq(user.refresh_token)
  end

  it 'finds by ID' do
    user_repository = described_class.new
    user = Factory.user
    user_id = user_repository.save(user).id

    retrieved_user = user_repository.find(user_id)
    expect(retrieved_user.email).to eq(user.email)
    expect(retrieved_user.token).to eq(user.token)
    expect(retrieved_user.token_expiration).to eq(user.token_expiration)
    expect(retrieved_user.refresh_token).to eq(user.refresh_token)
  end
end
