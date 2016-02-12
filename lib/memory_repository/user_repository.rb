module MemoryRepository
  class UserRepository
    def initialize
      @index = 1
      @records = {}
    end

    def save(object)
      assign_id_if_new(object)

      @records[object.email] = object
    end

    def find_by_email(email)
      @records[email]
    end

    def find(id)
      @records.values.select { |record| record.id == id }.first
    end

    private

    def assign_id_if_new(object)
      if object.id == nil
        object.id = @index
        @index += 1
      end
    end
  end
end
