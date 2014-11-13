require 'repository'

describe Repository do
  it 'registers and returns repositories' do
    user_repository = 'user_repository'
    Repository.register(:user, user_repository)
    expect(Repository.for(:user)).to eq(user_repository)
  end
end
