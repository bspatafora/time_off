require 'presenter/days_off'
require 'range'
require 'repository_object/day_off'

describe Presenter::DaysOff do
  before do
    @day_off_1 = RepositoryObject::DayOff.new(
      date: '2014-11-17',
      range: Range.new(description: Range::ALL_DAY))
    @day_off_2 = RepositoryObject::DayOff.new(
      date: '2014-11-18',
      range: Range.new(description: Range::MORNING))
    @day_off_3 = RepositoryObject::DayOff.new(
      date: '2014-11-19',
      range: Range.new(description: Range::AFTERNOON))
    @day_off_4 = RepositoryObject::DayOff.new(
      date: '2014-11-20',
      range: Range.new(description: Range::LATE_AFTERNOON))
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
