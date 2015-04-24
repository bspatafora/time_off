require 'time_range_factory'
require 'repository_object/day_off'

module ARRepository
  class DayOffRepository
    def save(object)
      DayOff.create(
        user_id: User.select('id').where(email: object.email).first.id,
        date: object.date,
        range: object.range.description,
        category: object.category,
        event_id: object.event_id,
        url: object.url)
    end

    def find_by_email(email)
      days_off = DayOff.joins(:user).where(users: { email: email })
      days_off.map { |day_off| to_domain_object(day_off, email) }
    end

    def destroy_by_event_id(event_id)
     day_off = DayOff.find_by(event_id: event_id)
     day_off.destroy
    end

    private

    def to_domain_object(day_off, email)
      RepositoryObject::DayOff.new(
        email: email,
        date: day_off.date,
        range: TimeRangeFactory.build(day_off.range),
        category: day_off.category,
        event_id: day_off.event_id,
        url: day_off.url)
    end
  end
end
