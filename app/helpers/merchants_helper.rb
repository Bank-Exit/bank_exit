module MerchantsHelper
  # Prevent users to manually refresh merchants
  # before delta time of 10 minutes.
  def can_refresh_merchants?(merchant_sync, delta: Setting::MERCHANTS_DELTA_SYNC_TIME)
    return true if merchant_sync.nil?
    return true if merchant_sync.error?
    return false if merchant_sync.pending?

    merchant_sync.ended_at < delta.ago
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

  def merchant_kyc_no_kyc(kyc, klass: 'w-7 h-7 text-[10px]')
    state = case kyc
            when nil then :unknown
            when true then :kyc
            else :no_kyc
            end

    label, color, title = case state
                          when :unknown then [I18n.t('unspecified'), 'bg-base-300 text-base-content', 'Unknown']
                          when :kyc then ['KYC', 'bg-error text-error-content', 'KYC']
                          when :no_kyc then ['No KYC', 'bg-success text-success-content', 'No KYC']
                          end

    content_tag(:div, class: 'avatar', title: title) do
      content_tag(
        :div,
        label,
        class: [
          klass,
          'flex items-center justify-center rounded-full',
          'select-none text-center font-bold leading-none',
          color
        ].join(' ')
      )
    end
  end
end
