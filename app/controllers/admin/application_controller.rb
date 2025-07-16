module Admin
  class ApplicationController < ApplicationController
    include HttpAuthConcern

    skip_after_action :record_page_view

    layout 'admin'
  end
end
