module UsersHelper
  def user_roles_select_helper
    User.roles.keys.map do |role|
      [
        User.human_enum_name(:role, role),
        role
      ]
    end
  end

  def user_badge_color_for_role(role)
    {
      super_admin: 'badge-error',
      admin: 'bage-warning',
      publisher: 'badge-info',
      moderator: 'badge-success'
    }[role.to_sym]
  end

  def color_for_role(role)
    {
      super_admin: 'error',
      admin: 'warning',
      publisher: 'info',
      moderator: 'success'
    }[role.to_sym]
  end
end
