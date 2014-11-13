require 'repository'
require 'ar_repository/user_repository'

Repository.register(:user, ARRepository::UserRepository.new)
