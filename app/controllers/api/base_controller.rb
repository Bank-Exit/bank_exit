module API
  class BaseController < ActionController::API
    include Localizable
    include TokenAuthenticable
    include Renderer
    include APIResponder

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    before_action :authenticate
    before_action :increment_requests_count

    private

    def increment_requests_count
      @current_api_token.increment!(:requests_count)
    end

    def should_redirect_to_localized_path?
      false
    end

    def per_page
      per <= 0 ? Pagy::DEFAULT[:limit] : per
    end

    def with_comments?
      params[:with_comments] == 'true'
    end
  end
end
