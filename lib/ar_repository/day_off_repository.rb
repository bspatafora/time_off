module ARRepository
  class DayOffRepository
    def save(object)
      user = User.find_by_email(object.email)
      user.days_off.create(date: object.date, category: object.category)
    end

    def find_by_email(email)
      User.find_by_email(email).days_off
    end
  end
end
