module CalendarService
  class Mock
    attr_reader :url

    def initialize
      @url = 'mock_url'
    end

    def create(day_off, token)
      OpenStruct.new(url: @url)
    end
  end
end
