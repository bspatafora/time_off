require 'repository_object/day_off'
require 'service'
require 'time_range_factory'

module Interactor
  class DayOff
    def self.all_for(user_id)
      day_off_repository.find_by_user_id(user_id)
    end

    def self.create(args)
      day_off = RepositoryObject::DayOff.new(
        user_id: args[:user_id],
        date: args[:date],
        range: TimeRangeFactory.build(args[:range]),
        category: args[:category]
      )

      event = calendar_service.create(day_off, token_for(args[:user_id]))
      day_off.event_id = event.event_id
      day_off.url = event.url

      day_off_repository.save(day_off)
    end

    def self.destroy(id)
      day_off = day_off_repository.find(id)
      user_id = day_off.user_id

      day_off_repository.destroy_by_event_id(day_off.event_id)
      calendar_service.destroy(day_off.event_id, token_for(user_id))
    end

    private

    def self.token_for(user_id)
      update_token(user_repository.find(user_id))
    end

    def self.update_token(user)
      return user.token if token_still_valid(user.token_expiration)
      token_data = token_service.refresh(user.refresh_token)
      user.token = token_data.token
      user.token_expiration = token_data.expiration
      user_repository.save(user)
      token_data.token
    end

    def self.token_still_valid(token_expiration)
      Time.at(token_expiration.to_i) > Time.now
    end

    def self.day_off_repository
      Service.for(:day_off_repository)
    end

    def self.user_repository
      Service.for(:user_repository)
    end

    def self.calendar_service
      Service.for(:calendar)
    end

    def self.token_service
      Service.for(:token)
    end
  end
end
