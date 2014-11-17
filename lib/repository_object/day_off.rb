module RepositoryObject
  class DayOff
    attr_reader :email, :date, :category

    def initialize(args)
      @email = args[:email]
      @date = args[:date]
      @category = args[:category]
    end
  end
end
