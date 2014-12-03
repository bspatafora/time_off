require 'ar_repository/day_off_repository'
require 'ar_repository/user_repository'
require 'calendar_service/google.rb'
require 'service'
require 'token_service/google.rb'

Service.register(:day_off_repository, ARRepository::DayOffRepository.new)
Service.register(:user_repository, ARRepository::UserRepository.new)
Service.register(:calendar, CalendarService::Google)
Service.register(:token, TokenService::Google)
