Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass
  config.assets.compile = true
  config.assets.digest = true

  # config.force_ssl = true

  config.log_level = :info
  config.log_formatter = ::Logger::Formatter.new

  config.action_mailer.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.sendgrid.net',
    :port                 => '587',
    :authentication       => :plain,
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :domain               => 'heroku.com',
    :enable_starttls_auto => true
  }

  config.middleware.use ExceptionNotification::Rack,
   :email => {
     :email_prefix         => "[Time Off error] ",
     :sender_address       => %{"Application Error" <no-reply@8thlight.com>},
     :exception_recipients => %w{bspatafora@8thlight.com}
   }

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.active_record.dump_schema_after_migration = false
end
