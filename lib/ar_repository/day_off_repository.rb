require 'repository_object/day_off'

module ARRepository
  class DayOffRepository
    def save(object)
      user = User.find_by(email: object.email)
      user.days_off.create(
        date: object.date,
        category: object.category,
        event_id: object.event_id,
        url: object.url)
    end

    def find_by_email(email)
      days_off = User.find_by(email: email).days_off
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
        category: day_off.category,
        event_id: day_off.event_id,
        url: day_off.url)
    end
  end
end
