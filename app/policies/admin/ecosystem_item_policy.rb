module Admin
  class EcosystemItemPolicy < ApplicationPolicy
    pre_check :require_admins!

    def index?
      true
    end

    def new?
      create?
    end

    def create?
      true
    end

    def edit?
      update?
    end

    def update?
      true
    end

    def destroy?
      true
    end
  end
end
