def current_date
 Time.now.to_s.split.first
end

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end
