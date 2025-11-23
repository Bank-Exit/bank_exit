module Admin
  class MerchantSyncPolicy < ApplicationPolicy
    pre_check :require_super_admins!

    def index?
      true
    end

    def show?
      index?
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
