module MemoryRepository
  class DayOffRepository
    def initialize
      @index = 1
      @records = {}
    end

    def save(object)
      assign_id_if_new(object)

      @records[object.user_id] ||= []
      @records[object.user_id] << object
      object
    end

    def find_by_user_id(user_id)
      @records[user_id]
    end

    def find(id)
      balh = []
      @records.values.each { |days_off| balh += days_off }
      balh.select { |record| record.id == id }.first
    end

    def destroy_by_event_id(event_id)
      @records.each do |email, days_off|
        days_off.delete_if { |day_off| day_off.event_id == event_id }
      end
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
