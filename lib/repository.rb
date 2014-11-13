class Repository
  def self.register(type, repository)
    repositories[type] = repository
  end

  def self.repositories
    @repositories ||= {}
  end

  def self.for(type)
    repositories[type]
  end
end
