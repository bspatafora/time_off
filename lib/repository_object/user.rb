module RepositoryObject
  class User
    attr_reader :email, :refresh_token

    def initialize(args)
      @email = args[:email]
      @refresh_token = args[:refresh_token]
    end
  end
end
