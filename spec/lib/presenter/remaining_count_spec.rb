require 'presenter/remaining_count'
require 'repository_object/day_off'

describe Presenter::RemainingCount do
  before do
    @flex_days_remaining_in_2014 = 0
    @allotted_flex_days = Rails.application.config.flex_days
    @allocated_holidays = 12
  end

  describe '#current_year' do 
    it 'returns the current year' do
      expect(described_class.new([], @flex_days_remaining_in_2014).current_year).to eq(Time.now.year)
    end
  end
  
  describe '#next_year' do 
    it 'returns the next year' do
      expect(described_class.new([], @flex_days_remaining_in_2014).next_year).to eq(Time.now.year + 1)
    end
  end

  describe '#previous_year' do 
    it 'returns the previous year' do
      expect(described_class.new([], @flex_days_remaining_in_2014).previous_year).to eq(Time.now.year - 1)
    end
  end

  describe '#flex_days' do
    context 'when user has no scheduled days off for current year' do
      it 'returns the number of flex days remaining' do
        days_off = []
        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@allotted_flex_days)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
      end
    end

    it 'ignores holidays' do
      current_year = 2015
      allow(Time).to receive(:now) { Time.new(current_year, 05, 15) }

      days_off = [RepositoryObject::DayOff.new(
                    date: "#{current_year}-08-22",
                    range: TimeRange.new(description: TimeRange::ALL_DAY),
                    category: 'Holiday')]

      remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
      expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
      expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days)
      expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
    end

    context 'when user has scheduled days off only in the current year' do
      before do
        @current_year = 2015
        allow(Time).to receive(:now) { Time.new(@current_year, 05, 15) }
      end

      it 'returns the number of flex days remaining with only full days' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-08-22",
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@current_year}-08-23",
                      range: TimeRange.new(description: TimeRange::ALL_DAY))]

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days - 2)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
      end

      it 'returns the number of flex days remaining with a half day' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-10", 
                      range: TimeRange.new(description: TimeRange::MORNING))]    

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days - 0.5)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
      end
    end

    context 'when user has scheduled days off only in the next year' do
      before do
        @current_year = 2015
        @next_year = @current_year + 1
        allow(Time).to receive(:now) { Time.new(@current_year, 05, 15) }
      end

      it 'returns the number of flex days remaining with only full days' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@next_year}-12-10",
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@next_year}-12-11",
                      range: TimeRange.new(description: TimeRange::ALL_DAY))]

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days - 2)
      end

      it 'returns the number of flex days remaining with a half day' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@next_year}-12-10", 
                      range: TimeRange.new(description: TimeRange::MORNING))]    

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days - 0.5)
      end
    end

    context 'when user has scheduled days off in both years' do
      before do
        @current_year = 2015
        @next_year = @current_year + 1
        allow(Time).to receive(:now) { Time.new(@current_year, 05, 15) }
      end

      it 'returns the number of flex days remaining for each year' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-10", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-11", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@next_year}-02-01", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY))]

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(@flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[1]).to eq(@allotted_flex_days - 2)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days - 1)
      end
    end

    # Flex days don’t expire until February 1st of the next calendar year.
    context 'when current month is January and user has flex days scheduled in January' do
      before do
        @current_calendar_year = 2016
        @previous_calendar_year = @current_calendar_year - 1
        allow(Time).to receive(:now) { Time.new(@current_calendar_year, 01, 15) }
      end

      it 'decrements the current year count if no flex days remain in previous year count' do
        days_off = []
        @allotted_flex_days.times do
          days_off << RepositoryObject::DayOff.new(
                        date: "#{@previous_calendar_year}-06-01",
                        range: TimeRange.new(description: TimeRange::ALL_DAY))
        end
        days_off << RepositoryObject::DayOff.new(
                      date: "#{@current_calendar_year}-01-15", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY))

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(0)
        expect(remaining_count.flex_days[1]).to eq(14)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
      end

      it 'decrements the previous year count if flex days do remain in previous year count' do
        days_off = []
        (@allotted_flex_days - 1).times do
          days_off << RepositoryObject::DayOff.new(
                        date: "#{@previous_calendar_year}-06-01",
                        range: TimeRange.new(description: TimeRange::ALL_DAY))
        end
        days_off << RepositoryObject::DayOff.new(
                      date: "#{@current_calendar_year}-01-15", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY))

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(0)
        expect(remaining_count.flex_days[1]).to eq(15)
        expect(remaining_count.flex_days[2]).to eq(@allotted_flex_days)
      end
    end

    context 'when user has flex days scheduled in January of current year and' +
            ' had flex days remaining from previous year' do
      before do
        @current_calendar_year = 2016
        @previous_calendar_year = @current_calendar_year - 1
        allow(Time).to receive(:now) { Time.new(@current_calendar_year, 02, 15) }
      end

      it 'does not decrement those days from current year count' do
        days_off = []
        (@allotted_flex_days - 1).times do
          days_off << RepositoryObject::DayOff.new(
                        date: "#{@previous_calendar_year}-06-01",
                        range: TimeRange.new(description: TimeRange::ALL_DAY))
        end
        days_off << RepositoryObject::DayOff.new(
                      date: "#{@current_calendar_year}-01-15", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY))

        remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
        expect(remaining_count.flex_days[0]).to eq(0)
        expect(remaining_count.flex_days[1]).to eq(15)
        expect(remaining_count.flex_days[2]).to eq(15)
      end
    end
  end

  describe '#holidays' do
    it 'returns the count of remaining holidays for the previous, current, and next years' do
      current_year = 2015
      previous_year = current_year - 1
      next_year = current_year + 1
      allow(Time).to receive(:now) { Time.new(current_year, 05, 15) }

      days_off = [RepositoryObject::DayOff.new(
                    date: "#{previous_year}-08-22",
                    range: TimeRange.new(description: TimeRange::ALL_DAY),
                    category: 'Holiday'),
                  RepositoryObject::DayOff.new(
                    date: "#{current_year}-08-23",
                    range: TimeRange.new(description: TimeRange::ALL_DAY),
                    category: 'Holiday'),
                  RepositoryObject::DayOff.new(
                    date: "#{current_year}-08-23",
                    range: TimeRange.new(description: TimeRange::ALL_DAY),
                    category: 'Holiday'),
                  RepositoryObject::DayOff.new(
                    date: "#{next_year}-08-23",
                    range: TimeRange.new(description: TimeRange::ALL_DAY),
                    category: 'Vacation')]

      remaining_count = described_class.new(days_off, @flex_days_remaining_in_2014)
      expect(remaining_count.holidays[0]).to eq(@allocated_holidays - 1)
      expect(remaining_count.holidays[1]).to eq(@allocated_holidays - 2)
      expect(remaining_count.holidays[2]).to eq(@allocated_holidays)
    end
  end
end
