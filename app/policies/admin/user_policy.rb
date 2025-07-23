module Admin
  class UserPolicy < ApplicationPolicy
    pre_check :allow_super_admins!, only: :analytics?

    def analytics?
      ENV.fetch('FF_ANALYTICS_ENABLED', false) == 'true'
    end
  end
end
