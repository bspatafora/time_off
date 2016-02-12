class Factory
  def self.user(overrides = {})
    attributes = {
      email: 'user@email.com',
      token: 'token',
      token_expiration: 123456789,
      refresh_token: 'refresh_token'
    }.merge(overrides)

    RepositoryObject::User.new(attributes)
  end

  def self.day_off(overrides = {})
    attributes = {
      user_id: 1,
      date: current_date,
      range: TimeRange.new(description: TimeRange::ALL_DAY),
      category: 'Vacation',
      event_id: 'event_id',
      url: 'url'
    }.merge(overrides)

    RepositoryObject::DayOff.new(attributes)
  end

  def self.current_date
    Date.today
  end
end
