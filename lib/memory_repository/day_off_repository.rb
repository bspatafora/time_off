module MemoryRepository
  class DayOffRepository
    def initialize
      @records = {}
    end

    def save(object)
      @records[object.email] ||= []
      @records[object.email] << object
    end

    def find_by_email(email)
      @records[email]
    end
  end
end
