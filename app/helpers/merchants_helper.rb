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

  def coins_list(coins, with_logo: false, with_name: true, size: 'w-5')
    content_tag(:ul, class: 'space-y-2') do
      coins.map do |coin|
        concat(content_tag(:li) do
          return coin.capitalize unless with_logo

          logo = image_tag "coins/logo-#{coin}.svg", class: "#{size} inline-flex"

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
end
