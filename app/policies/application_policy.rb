class ApplicationPolicy < ActionPolicy::Base
  authorize :user, optional: true

  private

  def allow_super_admins!
    allow! if user&.super_admin?
  end
end
