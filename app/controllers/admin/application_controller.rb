module Admin
  class ApplicationController < ApplicationController
    include HttpAuthConcern

    skip_after_action :record_page_view, if: :analytics_enabled?

    layout 'admin'
  end
end
