module TokenService
  class Mock
    attr_reader :token, :token_expiration

    def initialize
      @token = 'refreshed_token'
      @token_expiration = 'mock_token_expiration'
    end

    def refresh(refresh_token)
      OpenStruct.new(
        token: @token,
        expiration: @token_expiration)
    end
  end
end
