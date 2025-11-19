require 'feature_flag'

if FeatureFlag.enabled?(:analytics)
  Rails.application.configure do
    ActiveAnalytics.base_controller_class = 'Admin::BaseController'

    config.middleware.use Rack::CrawlerDetect

    config.after_initialize do
      require 'patches/active_analytics'
    end
  end
end
