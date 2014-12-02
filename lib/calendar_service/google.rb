require 'json'
require 'net/http'
require 'service'

module CalendarService
  class Google
    def add_event(day_off)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri)
      request.add_field('Content-Type', 'application/json')
      request.add_field('Authorization', "Bearer #{Token.for(day_off.email)}")
      request.body = body(day_off)
      event_link(http.request(request))
    end

    private

    def uri
      URI("https://www.googleapis.com/calendar/v3/calendars/#{Rails.application.config.calendar_id}/events?key=#{Rails.application.config.client_id}")
    end

    def body(day_off)
      date = day_off.date
      summary = summary(day_off.email, day_off.category)

      JSON.generate({ start: { date: date }, end: { date: end_date(date) }, summary: summary })
    end

    def end_date(date)
      (Date.parse(date) + 1).to_s
    end

    def summary(email, category)
      "#{email}—OOO (#{category})"
    end

    def event_link(response)
      JSON.parse(response.body)['htmlLink']
    end
  end

  class Token
    def self.for(email)
      user = Service.for(:user_repository).find_by_email(email)
      if token_is_still_valid(user.token_expiration)
        user.token
      else
        response = Net::HTTP.post_form(uri, body(user.refresh_token))
        data = JSON.parse(response.body)
        user.token = data['access_token']
        user.token_expiration = expires_at(data['expires_in'].to_i)
        Service.for(:user_repository).save(user)
        data['access_token']
      end
    end

    private

    def self.token_is_still_valid(expiration)
      Time.at(expiration) > Time.now
    end

    def self.uri
      URI('https://accounts.google.com/o/oauth2/token')
    end

    def self.body(refresh_token)
      {'refresh_token' => refresh_token,
        'client_id' => Rails.application.config.client_id,
        'client_secret' => Rails.application.config.client_secret,
        'grant_type' => 'refresh_token'}
    end

    def self.expires_at(seconds_from_now)
      Time.now.to_i + seconds_from_now
    end
  end
end
