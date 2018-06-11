Sidekiq.configure_server do |config|
  config.redis = { host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'] }
end
