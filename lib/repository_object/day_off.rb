module RepositoryObject
  class DayOff
    attr_reader :email, :date, :category, :url
    attr_writer :url

    def initialize(args)
      @email = args[:email]
      @date = args[:date]
      @category = args[:category]
      @url = args[:url]
    end
  end
end
