module RepositoryObject
  class User
    attr_reader :email, :refresh_token
    attr_accessor :token, :token_expiration

    def initialize(args)
      @email = args[:email]
      @token = args[:token]
      @token_expiration = args[:token_expiration]
      @refresh_token = args[:refresh_token]
    end
  end
end
