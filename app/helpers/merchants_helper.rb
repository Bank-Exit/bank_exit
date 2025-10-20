module MerchantsHelper
  # Prevent users to manually refresh merchants
  # before delta time of 10 minutes.
  def can_refresh_merchants?(last_updated_at:, delta: 10.minutes)
    Time.zone.at(last_updated_at) < delta.ago
  end

  def merchant_categories_select_helper
    # Some categories are defined with different key but
    # translation is the same (alias). To avoid duplicated
    # results on select input, we skip already displayed values.
    values = []

    categories = I18n.t('categories').map do |row|
      next if row.last.in?(values)

      values << row.last
      row
    end

    categories << [:other, I18n.t('simple_form.labels.category.other')]
    categories.compact_blank.map(&:reverse)
  end

  def merchant_continents_select_helper
    I18n.t('continents').invert
  end

  def coins_list(coins, with_logo: false, with_name: true, size: 'w-5', inline: false)
    content_tag(:div, class: "flex items-center gap-2 #{inline ? 'flex-row' : 'flex-col'}") do
      coins.map do |coin|
        concat(content_tag(:div, class: 'flex-shrink-0 min-w-max') do
          return coin.capitalize unless with_logo

          logo = if coin == 'lightning_contactless'
                   image_tag "coins/logo-#{coin}.svg", class: "#{size} inline-flex dark:bg-white dark:rounded-full dark:p-0.5 dark:border", title: coin.capitalize
                 else
                   image_tag "coins/logo-#{coin}.svg", class: "#{size} inline-flex", title: coin.capitalize
                 end

          if with_name
            "#{logo} #{coin.capitalize}".html_safe # rubocop:disable Rails/OutputSafety
          else
            logo.html_safe # rubocop:disable Rails/OutputSafety
          end
        end)
      end
    end
  end

  def merchant_icon_svg(icon, width: 80, height: 80, padding: 'p-2', naked: false)
    klass = ''

    unless naked
      klass = [
        padding,
        'rounded-full bg-primary text-primary-content'
      ].join(' ')
    end

    content_tag(
      :svg,
      width: width,
      height: height,
      xmlns: 'http://www.w3.org/2000/svg',
      class: klass
    ) do
      concat tag.use(href: "/map/spritesheet.svg##{icon}")
    end
  end

  def merchant_kyc_no_kyc(kyc, klass: 'w-10 h-10')
    shared_classes = "#{klass} uppercase flex items-center justify-center text-center rounded-full hover:scale-110 motion-safe:transition-transform select-none font-bold leading-none"

    if kyc.nil?
      content_tag(:span, I18n.t('unspecified'), class: shared_classes, title: 'Unknown')
    elsif kyc
      content_tag(:span, 'KYC', class: "#{shared_classes} bg-red-500 text-white", title: 'KYC')
    else
      content_tag(:p, 'No <br /> KYC'.html_safe, class: "#{shared_classes} bg-green-500 text-white", title: 'No KYC')
    end
  end
end
