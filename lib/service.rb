class Service
  def self.register(services)
    registered_services.merge!(services)
  end

  def self.registered_services
    @registered_services ||= {}
  end

  def self.for(type)
    registered_services[type]
  end
end
