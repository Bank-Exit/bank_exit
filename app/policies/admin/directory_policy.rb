module Admin
  class DirectoryPolicy < ApplicationPolicy
    def index?
      true
    end

    def new?
      create?
    end

    def create?
      admins_or_publisher?
    end

    def edit?
      update?
    end

    def update?
      admins_or_publisher?
    end

    def destroy?
      admins_or_publisher?
    end

    def update_position?
      update?
    end
  end
end
