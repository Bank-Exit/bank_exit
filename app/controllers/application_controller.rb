class ApplicationController < ActionController::Base
  prepend ActionPolicy::SimpleDelegator
  include HttpAuthConcern if Rails.env.staging?
  include Pagy::Backend

  rate_limit to: 100, within: 1.minute, by: -> { encrypted_ip }

  rescue_from ActionPolicy::Unauthorized, with: :unauthorized_access

  impersonates :user
  helper_method :comments_enabled?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  private

  def comments_enabled?
    FeatureFlag.enabled?(:comments)
  end

  def not_authenticated
    redirect_to main_url_helpers.new_session_path,
                alert: 'Vous devez être authentifié pour accéder à cette page',
                status: :see_other
  end

  def unauthorized_access(e)
    policy_name = e.policy.class.to_s.underscore
    message = t("#{policy_name}.#{e.rule}", scope: 'pundit', default: :default)

    redirect_to main_url_helpers.root_path, alert: message
  end

  def encrypted_ip
    Digest::SHA256.hexdigest(request.remote_ip)
  end

  # HACK: We must use `Rails.application.routes.url_helpers.root_path` explicitly here
  # because `root_path` or even `main_app.root_path` incorrectly resolve to the
  # engine’s root path when this controller is used in an engine or route-isolated context.
  # Using the full `Rails.application.routes.url_helpers` ensures the redirect goes
  # to the main application's true root path (`/`), avoiding unexpected routing behavior.
  def main_url_helpers
    Rails.application.routes.url_helpers
  end
end
