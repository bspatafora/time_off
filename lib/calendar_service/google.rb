require 'json'
require 'net/http'

module CalendarService
  class Google
    def self.create(day_off, token)
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(base_uri)
      request.add_field('Content-Type', 'application/json')
      request.add_field('Authorization', "Bearer #{token}")
      request.body = event_body(day_off)
      response = http.request(request)
      OpenStruct.new(
        event_id: parse_event_id(response),
        url: parse_event_url(response))
    end

    def self.destroy(event_id, token)
      uri = delete_uri(event_id)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Delete.new(uri)
      request.add_field('Authorization', "Bearer #{token}")
      http.request(request)
    end

    private

    def self.delete_uri(event_id)
      delete_url = base_url + "/" + event_id
      URI(delete_url)
    end

    def self.base_uri
      URI(base_url)
    end

    def self.base_url
      "https://www.googleapis.com/calendar/v3/calendars/#{Rails.application.config.calendar_id}/events"
    end

    def self.event_body(day_off)
      date = day_off.date
      summary = summary(day_off.email, day_off.category)
      JSON.generate({
        start: { date: date },
        end: { date: end_date(date) },
        summary: summary })
    end

    def self.end_date(date)
      (Date.parse(date) + 1).to_s
    end

    def self.summary(email, category)
      "#{email}—OOO (#{category})"
    end

    def self.parse_event_id(response)
      parse(response, 'id')
    end

    def self.parse_event_url(response)
      parse(response, 'htmlLink')
    end

    def self.parse(response, property)
      JSON.parse(response.body)[property]
    end
  end
end
