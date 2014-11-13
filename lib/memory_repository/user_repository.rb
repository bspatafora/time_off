module MemoryRepository
  class UserRepository
    def initialize
      @records = {}
    end

    def save(object)
      @records[object.email] = object
    end

    def find_by_email(email)
      @records[email]
    end
  end
end
