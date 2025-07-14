module Admin
  class CommentPolicy < ApplicationPolicy
    def index?
      admins_or_moderator?
    end

    def update?
      destroy?
    end

    def destroy?
      admins_or_moderator? && record.flag_reason.present?
    end
  end
end
