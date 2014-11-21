require 'repository_object/user'

module ARRepository
  class UserRepository
    def save(object)
      user = User.find_or_create_by(email: object.email)
      user.refresh_token = object.refresh_token if object.refresh_token
      user.token = object.token
      user.token_expiration = object.token_expiration
      user.save
    end

    def find_by_email(email)
      to_repository_object(User.find_by_email(email))
    end

    private

    def to_repository_object(user)
      RepositoryObject::User.new(
        email: user.email,
        token: user.token,
        token_expiration: user.token_expiration,
        refresh_token: user.refresh_token)
    end
  end
end
