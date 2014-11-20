class Service
  def self.register(type, service)
    services[type] = service
  end

  def self.services
    @services ||= {}
  end

  def self.for(type)
    services[type]
  end
end
