module FeatureFlag
  module_function

  def enabled?(key)
    flag = Rails.configuration.x.features.dig(key.to_s, :enabled)
    ActiveModel::Type::Boolean.new.cast(flag)
  end

  def disabled?(key)
    !enabled?(key)
  end
end
