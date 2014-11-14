ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'day off', 'days off'
  inflect.irregular 'day_off', 'days_off'
  inflect.irregular 'DayOff', 'DaysOff'
end
