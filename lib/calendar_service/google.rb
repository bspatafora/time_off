require 'json'
require 'service'

module CalendarService
  class Google
    def self.create(day_off, token)
      response = http_client.post(
        base_url,
        event_body(day_off),
        { 'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}" })
      OpenStruct.new(
        event_id: parse_event_id(response),
        url: parse_event_url(response))
    end

    def self.destroy(event_id, token)
      http_client.delete(
        delete_url(event_id),
        { 'Authorization' => "Bearer #{token}" })
    end

    private

    def self.http_client
      http = Service.for(:http_client)
      http.create('www.googleapis.com', 443)
      http.use_ssl = true
      http
    end

    def self.delete_url(event_id)
      base_url + "/" + event_id
    end

    def self.base_url
      "https://www.googleapis.com/calendar/v3/calendars/#{Rails.application.config.calendar_id}/events"
    end

    def self.event_body(day_off)
      email = Service.for(:user_repository).find(day_off.user_id).email
      date = day_off.date
      summary = summary(email, day_off.category)

      if day_off.range.all_day?
        all_day_event_body(date, summary)
      else
        part_day_event_body(date, summary, day_off.range)
      end
    end

    def self.all_day_event_body(date, summary)
      JSON.generate({
        start: { date: date },
        end: { date: end_date(date) },
        summary: summary })
    end

    def self.part_day_event_body(date, summary, range)
      JSON.generate({
        start: { dateTime: date + 'T' + range.start_time },
        end: { dateTime: date + 'T' + range.end_time },
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
