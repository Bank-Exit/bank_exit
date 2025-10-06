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

  field :address do |merchant, _|
    MerchantAddressBlueprint.render_as_hash(merchant)
  end

  field :social_contacts do |merchant, _|
    MerchantSocialContactBlueprint.render_as_hash(merchant)
  end
end
