require 'ar_repository/user_repository'
require 'ar_repository/day_off_repository'
require 'calendar_service/google.rb'
require 'service'

Service.register(:user_repository, ARRepository::UserRepository.new)
Service.register(:day_off_repository, ARRepository::DayOffRepository.new)
Service.register(:calendar, CalendarService::Google.new)
