require 'presenter/remaining_count'
require 'repository_object/day_off'

describe Presenter::RemainingCount do
  before do
    @current_year = Time.now.year
    @next_year = @current_year + 1
    @allotted_flex_days = Rails.application.config.flex_days
  end

  describe '#current_year' do 
    it 'returns the current year' do
      expect(described_class.new([]).current_year).to eq(Time.now.year)
    end
  end

  describe '#next_year' do 
    it 'returns the next year' do
      expect(described_class.new([]).next_year).to eq(Time.now.year + 1)
    end
  end

  describe 'flex_days methods' do
    context 'when user has no scheduled days off for current year' do
      it 'returns the number of flex days remaining' do
        days_off = []
        remaining_count = described_class.new(days_off)
        expect(remaining_count.flex_days_for_current_year).to eq(@allotted_flex_days)
      end
    end

    context 'when user has scheduled days off' do
      it 'returns the number of flex days remaining with only full days' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-10",
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-11",
                      range: TimeRange.new(description: TimeRange::ALL_DAY))]

        remaining_count = described_class.new(days_off)
        expect(remaining_count.flex_days_for_current_year).to eq(@allotted_flex_days - 2)
      end

      it 'returns the number of flex days remaining with a half day' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-10", 
                      range: TimeRange.new(description: TimeRange::MORNING))]    

        remaining_count = described_class.new(days_off)
        expect(remaining_count.flex_days_for_current_year).to eq(@allotted_flex_days - 0.5)
      end

      it 'returns the number of flex days remaining for the specified year' do
        days_off = [RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-10", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@current_year}-12-11", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY)),
                    RepositoryObject::DayOff.new(
                      date: "#{@next_year}-02-01", 
                      range: TimeRange.new(description: TimeRange::ALL_DAY))]
        flex_days_for_current_year = Rails.application.config.flex_days - 2

        remaining_count = described_class.new(days_off)
        expect(remaining_count.flex_days_for_current_year).to eq(flex_days_for_current_year)
      end
    end
  end
end
