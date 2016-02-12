require 'ar_repository/day_off_repository'
require 'ar_repository/user_repository'
require 'calendar_service/google'
require 'http_client/net_http_wrapper'
require 'service'
require 'token_service/google'

Service.register(
  day_off_repository: ARRepository::DayOffRepository.new,
  user_repository: ARRepository::UserRepository.new,
  calendar: CalendarService::Google,
  token: TokenService::Google,
  http_client: HTTPClient::NetHTTPWrapper.new
)
