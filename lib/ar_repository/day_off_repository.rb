require 'repository_object/day_off'

module ARRepository
  class DayOffRepository
    def save(object)
      user = User.find_by_email(object.email)
      user.days_off.create(
        date: object.date,
        category: object.category,
        url: object.url)
    end

    def find_by_email(email)
      days_off = User.find_by_email(email).days_off
      days_off.map { |day_off| to_domain_object(day_off, email) }
    end

    private

    def to_domain_object(day_off, email)
      RepositoryObject::DayOff.new(
        email: email,
        date: day_off.date,
        category: day_off.category,
        url: day_off.url)
    end
  end
end
