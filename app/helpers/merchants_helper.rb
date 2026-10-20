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

  def merchant_icon_svg(icon, size: 'size-5', naked: false)
    classes = [size, 'shrink-0']
    classes.push('p-2', 'rounded-full', 'bg-primary', 'text-primary-content') unless naked

    content_tag(:svg,
                xmlns: 'http://www.w3.org/2000/svg',
                class: classes.join(' ')) do
      tag.use(href: "/map/spritesheet.svg##{icon}")
    end
  end

  def merchant_kyc_no_kyc(kyc, klass: 'w-7 h-7 text-[10px]')
    state = case kyc
            when nil then :unknown
            when true then :kyc
            else
              :no_kyc
            end

    label, color, title = {
      unknown: [I18n.t('unspecified'), 'bg-base-300 text-base-content', 'Unknown'],
      kyc: ['KYC', 'bg-error text-error-content', 'KYC'],
      no_kyc: ['KYC', 'bg-success text-white font-bold', 'No KYC']
    }.fetch(state)

    content_tag(:div, class: 'avatar', title: title) do
      content_tag(
        :div,
        class: [
          klass,
          'relative flex items-center justify-center overflow-visible rounded-full',
          'select-none text-center font-bold leading-none',
          color
        ].join(' ')
      ) do
        safe_join([
          label,
          (
            if state == :no_kyc
              content_tag(
                :span,
                '',
                class: 'absolute h-1 w-[140%] rotate-[-45deg] bg-error',
                aria: { hidden: true }
              )
            end
          )
        ].compact)
      end
    end
  end
end
