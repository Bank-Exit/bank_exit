module API
  class BaseController < ActionController::API
    include TokenAuthenticable
    include Localizable
    include APIResponder

    before_action :authenticate
    before_action :increment_requests_count

    private

    def increment_requests_count
      @current_api_token.increment!(:requests_count)
    end

    def should_redirect_to_localized_path?
      false
    end
  end
end
