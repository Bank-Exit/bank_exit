module Admin
  class BaseController < ApplicationController
    include HttpAuthConcern

    around_action :switch_locale

    layout 'admin'

    private

    # Temporarily force the locale to French on the admin side
    # until full i18n integration is implemented.
    def switch_locale(&action)
      I18n.with_locale(:fr, &action)
    end
  end
end
