module Admin
  class AnnouncementPolicy < ApplicationPolicy
    pre_check :allow_super_admins!

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
