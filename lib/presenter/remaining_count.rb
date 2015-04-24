module Presenter
  class RemainingCount
    attr_reader :days_off, :current_year, :next_year, :previous_year

    def initialize(days_off, flex_days_remaining_in_2014)
      @days_off = days_off
      @flex_days_remaining_in_2014 = flex_days_remaining_in_2014
      @current_year = Time.now.year
      @next_year = current_year + 1
      @previous_year = current_year - 1
    end

    def flex_days
      return Array.new(3, allotted_flex_days) if days_off.empty?
      counts = flex_day_counts

      [counts[@previous_year] || allotted_flex_days,
       counts[@current_year] || allotted_flex_days,
       counts[@next_year] || allotted_flex_days]
    end

    def holidays
      return Array.new(3, allotted_holidays) if days_off.empty?
      counts = holiday_counts

      [counts[@previous_year] || allotted_holidays,
       counts[@current_year] || allotted_holidays,
       counts[@next_year] || allotted_holidays]
    end

    private

    def flex_day_counts
      counts = {}
      counts[2014] = @flex_days_remaining_in_2014
      days_off_by_year.each do |year, days_off_for_year|
        next if year == 2014
        return_value = flex_day_count(days_off_for_year, counts[year - 1])

        counts[year] = return_value[:current_year_count]
        counts[year - 1] = return_value[:previous_year_remaining]
      end
      counts
    end

    def holiday_counts
      counts = {}
      days_off_by_year.each do |year, days_off_for_year|
        counts[year] = holiday_count(days_off_for_year)
      end
      counts
    end

    def holiday_count(days_off_in_year)
      count = 0
      days_off_in_year.each do |day_off|
        count += day_off.range.time_value if day_off.category == 'Holiday'
      end
      allotted_holidays - count
    end

    def days_off_by_year
      days_off_by_year = {}
      days_off.each do |day_off|
        year_of_day_off = Date.parse(day_off.date).year

        if !days_off_by_year[year_of_day_off]
          days_off_by_year[year_of_day_off] = [day_off]
        else
          days_off_by_year[year_of_day_off] << day_off
        end
      end
      days_off_by_year
    end

    def flex_day_count(days_off_in_year, previous_year_remaining)
      count = 0
      days_off_in_year.each do |day_off|
        day_off_within_january = day_off_within_january?(day_off, Date.parse(day_off.date).year)
        if day_off_within_january && previous_year_remaining != 0
          previous_year_remaining -= day_off.range.time_value
        elsif day_off.category == 'Holiday'
          next
        else
          count += day_off.range.time_value
        end
      end
      { current_year_count: allotted_flex_days - count, previous_year_remaining: previous_year_remaining }
    end

    def allotted_flex_days
      Rails.application.config.flex_days
    end

    def allotted_holidays
      12
    end

    def day_off_within_january?(day_off, year)
      january_start = Date.parse("#{year}-01-01")
      january_end = Date.parse("#{year}-01-31")

      day_off_within_range?(january_start, january_end, day_off)
    end

    def day_off_within_year?(day_off, year)
      year_start = Date.parse("#{year}-01-01")
      year_end = Date.parse("#{year}-12-31")

      day_off_within_range?(year_start, year_end, day_off)
    end

    def day_off_within_range?(range_start, range_end, day_off)
      day_off_date = Date.parse(day_off.date)

      range_start <= day_off_date && day_off_date <= range_end
    end
  end
end
