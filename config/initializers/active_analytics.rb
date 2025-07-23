if ENV.fetch('FF_ANALYTICS_ENABLED', false) == 'true'
  Rails.application.configure do
    ActiveAnalytics.base_controller_class = 'Admin::BaseController'

    config.middleware.use Rack::CrawlerDetect
  end
end
