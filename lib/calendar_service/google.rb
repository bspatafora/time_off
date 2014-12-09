require 'json'
require 'service'

module CalendarService
  class Google
    def self.create(day_off, token)
      http = Service.for(:http_client)
      http.create(base_uri.host, base_uri.port)
      http.use_ssl = true
      headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" }
      response = http.post(base_url, event_body(day_off), headers)
      OpenStruct.new(
        event_id: parse_event_id(response),
        url: parse_event_url(response))
    end

    def self.destroy(event_id, token)
      http = Service.for(:http_client)
      http.create(base_uri.host, base_uri.port)
      http.use_ssl = true
      http.delete(delete_url(event_id), { 'Authorization' => "Bearer #{token}" })
    end

    private

    def self.delete_url(event_id)
      base_url + "/" + event_id
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
