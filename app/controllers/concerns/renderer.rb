module Renderer
  extend ActiveSupport::Concern

  private

  def render_unauthorized_authentication(e)
    response.headers['WWW-Authenticate'] = 'Bearer realm="Bank-Exit", error="invalid_token"'

    render json: {
      errors: [
        {
          status: 401,
          title: 'Unauthorized',
          detail: e.message
        }
      ]
    }, status: :unauthorized
  end

  def render_forbidden_authentication(e)
    response.headers['WWW-Authenticate'] = 'Bearer realm="Bank-Exit", error="disabled_or_expired_token"'

    render json: {
      errors: [
        {
          status: 403,
          title: 'Forbidden',
          detail: e.message
        }
      ]
    }, status: :forbidden
  end

  def render_not_found(e)
    locale = find_locale
    message =
      if e.is_a?(ActiveRecord::RecordNotFound)
        scope = "exceptions.#{e.model&.underscore}"
        I18n.t('not_found', scope: scope, default: e.message, locale: locale)
      end

    render json: {
      errors: [
        {
          status: 404,
          title: 'Not Found',
          detail: message
        }
      ]
    }, status: :not_found
  end
end
