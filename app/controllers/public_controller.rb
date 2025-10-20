class PublicController < ApplicationController
  include Localizable
  include Analyticable

  before_action :set_projects
  before_action :set_contacts
  before_action :set_default_command_palette_data

  private

  def set_projects
    @projects = Project.all(decorate: true)
  end

  def set_contacts
    @contacts = Contact.all
  end

  def set_default_command_palette_data
    default_merchants = Merchant.available.by_country(country_for_locale).includes(:logo_attachment).last(Pagy::DEFAULT[:limit])
    @default_merchants = MerchantDecorator.wrap(default_merchants)

    directories_spotlight = Directory.enabled.spotlights.includes(:logo_attachment, :string_translations, :text_translations, :coin_wallets).shuffle
    @directories_spotlight = DirectoryDecorator.wrap(directories_spotlight)
  end

  # Remove empty GET params from URL
  def clean_url(url)
    uri = URI.parse(url)
    query = Rack::Utils.parse_nested_query(uri.query).compact_blank
    uri.query = query.to_query.presence
    uri.to_s
  end

  def country_for_locale
    return 'GB' if I18n.locale == :en

    I18n.locale.upcase
  end
end
