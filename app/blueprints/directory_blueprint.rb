class DirectoryBlueprint < Blueprinter::Base
  identifier :id

  field :name
  field :description
  field :category

  field :directory_url do |directory, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.directory_url(directory.to_param)
  end

  field :last_survey_on do |directory, _|
    directory.updated_at.iso8601
  end

  field :logo_url,
        if: ->(_, directory, _) { directory.logo.attached? } do |directory, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.rails_blob_url(directory.logo)
  end

  field :banner_url,
        if: ->(_, directory, _) { directory.banner.attached? } do |directory, _|
    url_helpers = Rails.application.routes.url_helpers
    url_helpers.rails_blob_url(directory.banner)
  end

  association :coin_wallets,
              name: :coins,
              blueprint: CoinWalletBlueprint do |directory|
    directory.coin_wallets.enabled
  end

  association :contact_ways,
              name: :contacts,
              blueprint: ContactWayBlueprint do |directory|
    directory.contact_ways.enabled
  end

  association :delivery_zones,
              blueprint: DeliveryZoneBlueprint do |directory|
    directory.delivery_zones.enabled
  end

  view :with_comments do
    association :comments,
                blueprint: CommentBlueprint do |directory|
      directory.comments.available
    end
  end
end
