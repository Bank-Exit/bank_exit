class ApplicationPolicy < ActionPolicy::Base
  authorize :user, optional: true

  private

  def require_super_admins!
    deny! unless user&.super_admin?
  end

  def admins_or_moderator?
    user.super_admin? || user.admin? || user.moderator?
  end

  def admins_or_publisher?
    user.super_admin? || user.admin? || user.publisher?
  end
end
