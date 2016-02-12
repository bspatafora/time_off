require 'time_range_factory'
require 'repository_object/day_off'

module ARRepository
  class DayOffRepository
    def save(object)
      day_off = DayOff.create(
        user_id: object.user_id,
        date: object.date,
        range: object.range.description,
        category: object.category,
        event_id: object.event_id,
        url: object.url
      )

      repository_object(day_off)
    end

    def find_by_user_id(user_id)
      DayOff.where(user_id: user_id).map { |day_off| repository_object(day_off) }
    end

    def find(id)
      repository_object(DayOff.find(id))
    end

    def destroy_by_event_id(event_id)
      DayOff.find_by(event_id: event_id).destroy
    end

    private

    def repository_object(day_off)
      RepositoryObject::DayOff.new(
        id: day_off.id,
        user_id: day_off.user_id,
        date: day_off.date,
        range: TimeRangeFactory.build(day_off.range),
        category: day_off.category,
        event_id: day_off.event_id,
        url: day_off.url
      )
    end
  end
end
