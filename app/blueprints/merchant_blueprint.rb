class MerchantBlueprint < Blueprinter::Base
  identifier :identifier, name: :id

  field :name
  field :description
  field :category
  field :coins
  field :ask_kyc
  field :opening_hours
  field :website
  field :email
  field :phone
  field :merchant_url do |merchant, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.merchant_url(merchant.to_param)
  end

  field :last_survey_on do |merchant, _|
    merchant.last_survey_on.to_s
  end

  field :logo_url,
        if: ->(_, merchant, _) { merchant.logo.attached? } do |merchant, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.rails_blob_url(merchant.logo)
  end

  field :banner_url,
        if: ->(_, merchant, _) { merchant.banner.attached? } do |merchant, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.rails_blob_url(merchant.banner)
  end

  field :address do |merchant, _|
    MerchantAddressBlueprint.render_as_hash(merchant)
  end

  field :social_contacts do |merchant, _|
    MerchantSocialContactBlueprint.render_as_hash(merchant)
  end

  view :with_comments do
    association :comments,
                blueprint: CommentBlueprint do |merchant|
      merchant.comments.available
    end
  end
end
