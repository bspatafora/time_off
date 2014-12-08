require 'json'

module HTTPClient
  class Mock
    attr_reader :received_host, :received_port, :received_post_url,
                :received_body, :received_post_headers, :received_delete_url,
                :received_delete_headers
    attr_accessor :use_ssl

    def create(host, port)
      @received_host = host
      @received_port = port
    end

    def post(url, body, headers)
      @received_post_url = url
      @received_body = body
      @received_post_headers = headers
      OpenStruct.new(
        body: JSON.generate({
          htmlLink: 'event/url',
          id: 'event_id' }))
    end

    def delete(url, headers)
      @received_delete_url = url
      @received_delete_headers = headers 
    end
  end
end
