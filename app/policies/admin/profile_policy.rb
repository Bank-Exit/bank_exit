module Admin
  class ProfilePolicy < ApplicationPolicy
    alias_rule :edit?, to: :update?

    def update?
      record == user
    end
  end
end
