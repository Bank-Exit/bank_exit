module Renderer
  extend ActiveSupport::Concern

  private

  def render_not_found(exception)
    locale = find_locale
    message =
      if exception.is_a?(ActiveRecord::RecordNotFound)
        scope = "exceptions.#{exception.model&.underscore}"
        I18n.t('not_found', scope: scope, default: exception.message, locale: locale)
      end

    render json: {
      errors: [
        {
          status: '404',
          title: 'Not Found',
          detail: message
        }
      ]
    }, status: :not_found
  end
end
