module Admin
  class BaseController < ApplicationController
    before_action :require_login

    include Localizable

    layout 'admin'

    private

    def should_redirect_to_localized_path?
      false
    end
  end
end
