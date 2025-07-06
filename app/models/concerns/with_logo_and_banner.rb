module WithLogoAndBanner
  extend ActiveSupport::Concern

  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpeg'].freeze

  included do
    attr_accessor :remove_logo, :remove_banner

    has_one_attached :logo do |attachable|
      attachable.variant :thumb, resize_to_limit: [100, 100], preprocessed: true
    end
    has_one_attached :banner do |attachable|
      attachable.variant :thumb, resize_to_limit: [1024, 768], preprocessed: true
    end

    validates :logo, :banner,
              content_type: {
                in: ACCEPTED_CONTENT_TYPES,
                spoofing_protection: true
              },
              size: { less_than: 1.megabyte }

    before_save :purge_logo_if_requested
    before_save :purge_banner_if_requested
  end

  private

  def purge_logo_if_requested
    logo.purge if ActiveModel::Type::Boolean.new.cast(remove_logo)
  end

  def purge_banner_if_requested
    banner.purge if ActiveModel::Type::Boolean.new.cast(remove_banner)
  end
end
