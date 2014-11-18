require 'presenter/days_off'
require 'repository_object/day_off'

describe Presenter::DaysOff do
  it 'returns the days off in ascending order' do
    day_off_1 = RepositoryObject::DayOff.new(date: '2014-11-17', category: '')
    day_off_2 = RepositoryObject::DayOff.new(date: '2014-11-18', category: '')
    day_off_3 = RepositoryObject::DayOff.new(date: '2014-11-19', category: '')
    unordered_list = [day_off_2, day_off_3, day_off_1]
    ascending_ordered_list = [day_off_1, day_off_2, day_off_3]

    days_off = Presenter::DaysOff.new(unordered_list)
    expect(days_off.list).to eq(ascending_ordered_list)
  end
end
