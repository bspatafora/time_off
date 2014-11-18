module Presenter
  class DaysOff
    def initialize(days_off)
      @days_off = days_off
    end

    def list
      @days_off.sort { |a, b| a.date <=> b.date }
    end
  end
end
