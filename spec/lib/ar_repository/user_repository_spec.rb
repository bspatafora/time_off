require 'ar_repository/user_repository'
require 'lib/shared_examples/user_repository'

describe ARRepository::UserRepository do
  it_behaves_like 'a user repository'
end
