module Localizable
  extend ActiveSupport::Concern

  included do
    before_action :redirect_to_localized_path, if: -> { should_redirect_to_localized_path? }
    around_action :switch_locale

    helper_method :find_locale
  end

  private

  def should_redirect_to_localized_path?
    return false unless params[:locale].nil?

    !params[:controller].in?(
      ['licenses', 'maps', 'maps/referers', 'addresses/searches']
    ) &&
      !params[:action].in?(['toggle_atms'])
  end

  def redirect_to_localized_path
    redirect_to url_for(locale: find_locale.to_s, params: request.query_parameters)
  end

  def switch_locale(&action)
    locale = find_locale
    session[:last_known_locale] = locale

    I18n.with_locale(locale, &action)
  end

  def find_locale
    raw_locale = params[:locale] || session[:last_known_locale] || I18n.default_locale
    I18n.available_locales.map(&:to_s).include?(raw_locale.to_s) ? raw_locale : I18n.default_locale
  end
end
