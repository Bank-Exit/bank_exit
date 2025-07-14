module Admin
  module Merchants
    class DirectoryConverterPolicy < ApplicationPolicy
      def create?
        admins_or_publisher? && !Directory.exists?(merchant_id: record.id)
      end
    end
  end
end
