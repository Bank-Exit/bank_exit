module Admin
  class UserPolicy < ApplicationPolicy
    pre_check :require_super_admins!, only: %i[
      index? new? create? destroy?
      impersonate? analytics? mission_control?
    ]

    def index?
      true
    end

    def new?
      create?
    end

    def create?
      true
    end

    def show?
      user.super_admin? || user.id == record.id
    end

    def edit?
      update?
    end

    def update?
      show?
    end

    def destroy?
      true
    end

    def impersonate?
      user.id != record.id
    end

    def analytics?
      FeatureFlag.enabled?(:analytics)
    end

    def mission_control?
      true
    end
  end
end
