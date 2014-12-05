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

    def destroy_by_event_id(event_id)
      @records.each do |email, days_off|
        days_off.delete_if { |day_off| day_off.event_id == event_id }
      end
    end
  end
end
