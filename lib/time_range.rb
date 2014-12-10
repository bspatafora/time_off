class TimeRange
  ALL_DAY = 'all_day'
  MORNING = 'morning'
  AFTERNOON = 'afternoon'
  LATE_AFTERNOON = 'late_afternoon'

  attr_reader :description

  def initialize(args)
    @start_time = args[:start_time]
    @end_time = args[:end_time]
    @description = args[:description]
  end

  def start_time
    raise DayOffRangeError, "All day range does not have start time" if @start_time.nil?
    @start_time + Rails.application.config.time_zone_offset
  end

  def end_time
    raise DayOffRangeError, "All day range does not have end time" if @end_time.nil?
    @end_time + Rails.application.config.time_zone_offset
  end

  def all_day?
    @description == ALL_DAY
  end

  def time_value
    all_day? ? 1 : 0.5
  end
end

class DayOffRangeError < Exception; end
