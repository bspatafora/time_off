module CalendarService
  class Mock
    attr_reader :url

    def initialize
      @url = 'mock_url'
    end

    def addEvent(args)
      @url
    end
  end
end
