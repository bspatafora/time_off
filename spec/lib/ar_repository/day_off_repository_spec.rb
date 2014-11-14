require 'ar_repository/day_off_repository'
require 'lib/shared_examples/day_off_repository'

describe ARRepository::DayOffRepository do
  it_behaves_like 'a day off repository'
end
