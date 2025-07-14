if ENV.fetch('FF_ANALYTICS_ENABLED') == 'true'
  Rails.application.configure do
    ActiveAnalytics.base_controller_class = 'Admin::ApplicationController'

    config.middleware.use Rack::CrawlerDetect
  end
end
