require 'factory'
require 'presenter/days_off'
require 'time_range'

describe Presenter::DaysOff do
  before do
    @day_off_1 = Factory.day_off(
      date: '2014-11-17',
      range: TimeRange.new(description: TimeRange::ALL_DAY))
    @day_off_2 = Factory.day_off(
      date: '2014-11-18',
      range: TimeRange.new(description: TimeRange::MORNING))
    @day_off_3 = Factory.day_off(
      date: '2014-11-19',
      range: TimeRange.new(description: TimeRange::AFTERNOON))
    @day_off_4 = Factory.day_off(
      date: '2014-11-20',
      range: TimeRange.new(description: TimeRange::LATE_AFTERNOON))
  end

  it 'returns the days off in ascending order' do
    unordered_list = [@day_off_4, @day_off_2, @day_off_3, @day_off_1]
    ascending_ordered_list = [@day_off_1, @day_off_2, @day_off_3, @day_off_4]

    days_off = Presenter::DaysOff.new(unordered_list)
    expect(days_off.list).to eq(ascending_ordered_list)
  end

  it 'adds a range description to each day off' do
    days_off = Presenter::DaysOff.new(
      [@day_off_1, @day_off_2, @day_off_3, @day_off_4])
    expect(days_off.list[0].range_description).to eq('All day')
    expect(days_off.list[1].range_description).to eq('Morning')
    expect(days_off.list[2].range_description).to eq('Afternoon')
    expect(days_off.list[3].range_description).to eq('Late afternoon')
  end
end
