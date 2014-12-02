module CalendarService
  class Mock
    attr_reader :url

    def initialize
      @url = 'mock_url'
    end

    def add_event(args)
      @url
    end
  end
end
