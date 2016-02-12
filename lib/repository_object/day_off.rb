module RepositoryObject
  class DayOff
    attr_reader :id, :user_id, :date, :range, :category, :event_id, :url
    attr_writer :id, :event_id, :url

    def initialize(args)
      @id = args[:id]
      @user_id = args[:user_id]
      @date = args[:date]
      @range = args[:range]
      @category = args[:category]
      @event_id = args[:event_id]
      @url = args[:url]
    end
  end
end
