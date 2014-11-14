require 'memory_repository/day_off_repository'
require 'lib/shared_examples/day_off_repository'

describe MemoryRepository::DayOffRepository do
  it_behaves_like 'a day off repository'
end
