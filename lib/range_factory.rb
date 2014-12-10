require 'range'

class RangeFactory
  def self.build(description)
    case description
    when Range::ALL_DAY
      args = { description: Range::ALL_DAY }
    when Range::MORNING
      args = { description: Range::MORNING,
               start_time: '09:00:00',
               end_time: '13:00:00' }
    when Range::AFTERNOON
      args = { description: Range::AFTERNOON,
               start_time: '11:00:00',
               end_time: '15:00:00' }
    when Range::LATE_AFTERNOON
      args = { description: Range::LATE_AFTERNOON,
               start_time: '13:00:00',
               end_time: '17:00:00' }
    end
    Range.new(args)
  end
end
