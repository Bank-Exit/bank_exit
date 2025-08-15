return unless defined?(Debugbar)

Debugbar.configure do |config|
  config.ignore_request = lambda { |env|
    [
      Debugbar.config.prefix,
      '/assets',
      '/rails/active_storage',
      '/manifest.json',
      '/maps/referer'
    ].any? do |prefix|
      env['PATH_INFO'].start_with?(prefix)
    end
  }
end
