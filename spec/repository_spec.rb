require 'service'

describe Service do
  it 'registers and returns services' do
    user_repository = 'user_repository'
    Service.register(:user_repository, user_repository)
    expect(Service.for(:user_repository)).to eq(user_repository)
  end
end
