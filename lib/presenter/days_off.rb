require 'range'

module Presenter
  class DaysOff
    def initialize(days_off)
      @days_off = days_off
    end

    def list
      @days_off.sort! { |a, b| a.date <=> b.date }
      @days_off.map { |day_off| add_range_description_to(day_off) }
    end

    private

    def add_range_description_to(day_off)
      case day_off.range.description
      when Range::ALL_DAY
        range_description = 'All day'
      when Range::MORNING
        range_description = 'Morning'
      when Range::AFTERNOON
        range_description = 'Afternoon'
      when Range::LATE_AFTERNOON
        range_description = 'Late afternoon'
      end

      day_off.define_singleton_method(:range_description) do
        range_description
      end

      day_off
    end
  end
end
