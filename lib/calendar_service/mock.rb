module CalendarService
  class Mock
    attr_reader :event_id, :url, :added_events, :destroyed_events

    def initialize
      @event_id = 'mock_event_id'
      @url = 'mock_url'
      @added_events = []
      @destroyed_events = []
    end

    def create(day_off, token)
      @added_events << day_off
      OpenStruct.new(
        event_id: @event_id,
        url: @url)
    end

    def destroy(event_id, token)
      @destroyed_events << event_id
    end
  end
end
