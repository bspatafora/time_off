require 'repository_object/user'

module ARRepository
  class UserRepository
    def save(object)
      user = User.find_or_create_by(email: object.email)

      if object.refresh_token
        user.refresh_token = object.refresh_token
      end

      user.update!(
        token: object.token,
        token_expiration: object.token_expiration
      )
      repository_object(user)
    end

    def find_by_email(email)
      repository_object(User.find_by(email: email))
    end

    def find(id)
      repository_object(User.find(id))
    end

    private

    def repository_object(user)
      RepositoryObject::User.new(
        id: user.id,
        email: user.email,
        token: user.token,
        token_expiration: user.token_expiration,
        refresh_token: user.refresh_token
      )
    end
  end
end
