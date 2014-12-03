require 'repository_object/day_off'
require 'service'

module Interactor
  class DayOff
    def self.all_for(email)
      day_off_repository.find_by_email(email)
    end

    def self.create(args)
      day_off = RepositoryObject::DayOff.new(
        email: args[:email],
        date: args[:date],
        category: args[:category])
      user = user_repository.find_by_email(args[:email])
      token = update_token(user)
      event = calendar_service.create(day_off, token)
      day_off.url = event.url
      day_off_repository.save(day_off)
    end

    private

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
