module Analyticable
  extend ActiveSupport::Concern

  included do
    after_action :record_page_view, if: :record_page?

    helper_method :analytics_enabled?
  end

  private

  def record_page_view
    ActiveAnalytics.record_request(request)
  end

  def record_page?
    analytics_enabled? &&
      !logged_in? &&
      !request.is_crawler? &&
      response.content_type&.start_with?('text/html') &&
      params[:debug].blank? # from Github issue
  end

  def analytics_enabled?
    ENV.fetch('FF_ANALYTICS_ENABLED', false) == 'true'
  end
end
