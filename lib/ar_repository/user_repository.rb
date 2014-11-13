module ARRepository
  class UserRepository
    def save(object)
      User.create( { email: object.email, refresh_token: object.refresh_token } )
    end

    def find_by_email(email)
      User.find_by_email(email)
    end
  end
end
