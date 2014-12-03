require 'json'
require 'net/http'

module CalendarService
  class Google
    def self.create(day_off, token)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri)
      request.add_field('Content-Type', 'application/json')
      request.add_field('Authorization', "Bearer #{token}")
      request.body = body(day_off)
      response = http.request(request)
      OpenStruct.new(url: event_url(response))
    end

    private

    def self.uri
      URI("https://www.googleapis.com/calendar/v3/calendars/#{Rails.application.config.calendar_id}/events")
    end

    def self.body(day_off)
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

    def self.event_url(response)
      JSON.parse(response.body)['htmlLink']
    end
  end
end
