require 'calendar_service/google'
require 'http_client/mock'
require 'repository_object/day_off'
require 'service'
require 'time_range'

describe CalendarService::Google do
  before do
    @http_client = HTTPClient::Mock.new
    Service.register(:http_client, @http_client)
    @token = '70k3n'
  end

  describe '#create' do
    before do
      @day_off = RepositoryObject::DayOff.new(
        email: 'user@email.com',
        date: '2014-12-08',
        range: TimeRange.new(description: TimeRange::ALL_DAY),
        category: 'Vacation')
    end

    it 'creates a new HTTP client with the correct host and port' do
      described_class.create(@day_off, @token)
      expect(@http_client.received_host).to eq('www.googleapis.com')
      expect(@http_client.received_port).to eq(443)
    end

    it 'uses SSL' do
      described_class.create(@day_off, @token)
      expect(@http_client.use_ssl).to be true
    end

    context 'when creating an all-day event' do
      it 'makes a POST request with the correct parameters' do
        described_class.create(@day_off, @token)

        expect(@http_client.received_post_url).to match(
          /^https:\/\/www.googleapis.com\/calendar\/v3\/calendars\/.*\/events$/)

        expect(@http_client.received_body).to eq(
          "{\"start\":{\"date\":\"2014-12-08\"},\"end\":{\"date\":\"2014-12-09\"},\"summary\":\"user@email.com—OOO (Vacation)\"}")

        expect(@http_client.received_post_headers).to eq(
          {"Content-Type"=>"application/json", "Authorization"=>"Bearer 70k3n"})
      end
    end

    context 'when creating a part-day event' do
      it 'makes a POST request with the correct parameters' do
        partial_day_off = RepositoryObject::DayOff.new(
          email: 'user@email.com',
          date: '2014-12-09',
          range: TimeRange.new(
            description: TimeRange::MORNING,
            start_time: '09:00:00',
            end_time: '13:00:00'),
          category: 'Sick')
        described_class.create(partial_day_off, @token)

        expect(@http_client.received_post_url).to match(
          /^https:\/\/www.googleapis.com\/calendar\/v3\/calendars\/.*\/events$/)

        expect(@http_client.received_body).to eq(
          "{\"start\":{\"dateTime\":\"2014-12-09T09:00:00-06:00\"},\"end\":{\"dateTime\":\"2014-12-09T13:00:00-06:00\"},\"summary\":\"user@email.com—OOO (Sick)\"}")

        expect(@http_client.received_post_headers).to eq(
          {"Content-Type"=>"application/json", "Authorization"=>"Bearer 70k3n"})
      end
    end

    it 'returns an object containing the event ID and URL' do
      event_data = described_class.create(@day_off, @token)
      expect(event_data.event_id).to eq('event_id')
      expect(event_data.url).to eq('event/url')
    end
  end

  describe '#destroy' do
    before do
      @event_id = '3v3n71d'
    end

    it 'creates a new HTTP client with the correct host and port' do
      described_class.destroy(@event_id, @token)
      expect(@http_client.received_host).to eq('www.googleapis.com')
      expect(@http_client.received_port).to eq(443)
    end

    it 'makes a DELETE request with the correct parameters' do
      described_class.destroy(@event_id, @token)
      expect(@http_client.received_delete_url).to match(
        /^https:\/\/www.googleapis.com\/calendar\/v3\/calendars\/.*\/events\/#{Regexp.quote(@event_id)}$/)
      expect(@http_client.received_delete_headers).to eq(
        {"Authorization"=>"Bearer 70k3n"})
    end
  end
end
