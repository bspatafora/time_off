require 'time_range'

class TimeRangeFactory
  def self.build(description)
    case description
    when TimeRange::ALL_DAY
      args = { description: TimeRange::ALL_DAY }
    when TimeRange::MORNING
      args = { description: TimeRange::MORNING,
               start_time: '09:00:00',
               end_time: '13:00:00' }
    when TimeRange::AFTERNOON
      args = { description: TimeRange::AFTERNOON,
               start_time: '11:00:00',
               end_time: '15:00:00' }
    when TimeRange::LATE_AFTERNOON
      args = { description: TimeRange::LATE_AFTERNOON,
               start_time: '13:00:00',
               end_time: '17:00:00' }
    end
    TimeRange.new(args)
  end
end
