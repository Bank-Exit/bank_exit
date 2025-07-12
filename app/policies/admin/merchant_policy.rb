module Admin
  class MerchantPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      true
    end

    def edit?
      update?
    end

    def update?
      true
    end

    def destroy?
      record.deleted_at.present?
    end

    def reactivate?
      destroy?
    end
  end
end
