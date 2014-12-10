require 'net/http'

module HTTPClient
  class NetHTTPWrapper
    def create(host, port)
      @client = Net::HTTP.new(host, port)
    end

    def use_ssl=(flag)
      @client.use_ssl = flag
    end

    def post(url, body, headers)
      @client.post(url, body, headers)
    end

    def delete(url, headers)
      @client.delete(url, headers)
    end

    def post_form(uri, params)
      Net::HTTP.post_form(uri, params)
    end
  end
end
