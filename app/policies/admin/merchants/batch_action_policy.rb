module Admin
  module Merchants
    class BatchActionPolicy < ApplicationPolicy
      def update?
        destroy?
      end

      def destroy?
        admins_or_publisher?
      end
    end
  end
end
