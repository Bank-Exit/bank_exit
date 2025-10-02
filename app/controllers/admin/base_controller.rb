module Admin
  class BaseController < ApplicationController
    before_action :require_login

    include Localizable

    layout 'admin'

    private

    def should_redirect_to_localized_path?
      false
    end

    # Temporarily force the locale to French on the admin side
    # until full i18n integration is implemented.
    def find_locale
      :fr
    end
  end
end
