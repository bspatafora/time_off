module RepositoryObject
  class DayOff
    attr_reader :email, :date, :category, :event_id, :url
    attr_writer :event_id, :url

    def initialize(args)
      @email = args[:email]
      @date = args[:date]
      @category = args[:category]
      @event_id = args[:event_id]
      @url = args[:url]
    end
  end
end
