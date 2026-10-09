module MapsHelper
  def map_css_height
    'md:h-[calc(100dvh-64px)]'
  end

  def map_enabled_disabled_collection_values_for_select
    [
      [t('enabled'), true],
      [t('disabled'), false]
    ]
  end

  def map_attribution_html
    "#{image_tag('monero-map-logo.png', class: 'inline w-7 py-1', width: 28, height: 28, alt: 'Monero map logo')} #{URI(root_url).host}"
  end

  def embed_map_attribution_html
    link_to map_attribution_html, root_url, title: I18n.t('welcome.index.title')
  end

  def merchants_as_table?
    session[:merchants_display] == 'table'
  end

  def merchants_as_grid?
    session[:merchants_display] == 'grid'
  end

  def include_atms?
    session[:include_atms]
  end

  def map_merchants_filters_count
    count = main_map_merchants_filters_count
    count += 1 if include_atms?

    %i[onchain_only delivery order_by_survey].each do |p|
      count += 1 if params[p].present?
    end

    count
  end

  def main_map_merchants_filters_count
    count = 0

    %i[search country continent category coins no_kyc].each do |p|
      count += 1 if params[p].present?
    end

    count
  end
end
