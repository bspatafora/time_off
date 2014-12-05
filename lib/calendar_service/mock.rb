module CalendarService
  class Mock
    attr_reader :event_id, :url, :destroyed_events

    def initialize
      @event_id = 'mock_event_id'
      @url = 'mock_url'
      @destroyed_events = []
    end

    def create(day_off, token)
      OpenStruct.new(
        event_id: @event_id,
        url: @url)
    end

    def destroy(event_id, token)
      @destroyed_events << event_id
    end
  end
end
