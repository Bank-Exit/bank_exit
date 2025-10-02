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
      admins_or_publisher?
    end

    def destroy?
      record.deleted_at.present? && admins_or_moderator?
    end

    def reactivate?
      destroy?
    end
  end
end
