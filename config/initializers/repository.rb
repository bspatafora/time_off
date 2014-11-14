require 'repository'
require 'ar_repository/user_repository'
require 'ar_repository/day_off_repository'

Repository.register(:user, ARRepository::UserRepository.new)
Repository.register(:days_off, ARRepository::DayOffRepository.new)
