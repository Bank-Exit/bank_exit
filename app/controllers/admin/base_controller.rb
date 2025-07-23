module Admin
  class BaseController < ApplicationController
    include HttpAuthConcern

    layout 'admin'
  end
end
