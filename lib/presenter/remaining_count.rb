module Presenter
  class RemainingCount
    
    attr_reader :days_off

    def initialize(days_off)
      @days_off = days_off
    end

    def current_year
      Time.now.year
    end

    def next_year
      current_year + 1
    end

    def flex_days_for_current_year
      return allotted_flex_days if days_off.empty?

      scheduled_time_off = 0
      days_off.each do |day_off| 
        if within_flex_day_year(day_off) 
          scheduled_time_off += day_off.range.time_value
        end
      end 

      allotted_flex_days - scheduled_time_off
    end

    private

    def allotted_flex_days
      Rails.application.config.flex_days
    end

    def within_flex_day_year(day_off)
      day_off_date              = Date.parse(day_off.date)
      start_of_current_year     = Date.parse("#{self.current_year}-01-01")
      february_1st_of_next_year = Date.parse("#{self.next_year}-02-01")

      start_of_current_year < day_off_date &&
      day_off_date < february_1st_of_next_year
    end
  end
end
