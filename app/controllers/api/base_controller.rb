module API
  class BaseController < ActionController::API
    include Localizable
    include APIResponder

    def should_redirect_to_localized_path?
      false
    end
  end
end
