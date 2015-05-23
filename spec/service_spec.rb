require 'service'

describe Service do
  it 'registers and returns services' do
    Service.register(user_repository: 'user_repository')

    expect(Service.for(:user_repository)).to eq('user_repository')
  end
end
