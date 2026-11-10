module KYCBadgesHelper
  def kyc_badge(size: :sm)
    render_kyc_badge(
      label: 'KYC',
      color: 'kyc-badge-error',
      title: 'KYC',
      badge_class: size
    )
  end

  def no_kyc_badge(size: :sm, with_strike: true)
    render_kyc_badge(
      label: 'KYC',
      color: 'kyc-badge-success',
      title: I18n.t('no_kyc'),
      badge_class: size,
      with_strike: with_strike
    )
  end

  def unspecified_kyc_badge(size: :sm)
    render_kyc_badge(
      label: I18n.t('unspecified'),
      color: 'kyc-badge-unknown',
      title: I18n.t('unspecified'),
      badge_class: size
    )
  end

  private

  def render_kyc_badge(label:, color:, title:, badge_class:, with_strike: false)
    size_class = {
      xs: 'kyc-badge-xs',
      sm: 'kyc-badge-sm',
      md: 'kyc-badge-md',
      lg: 'kyc-badge-lg',
      xl: 'kyc-badge-xl',
      '2xl': 'kyc-badge-2xl'
    }.fetch(badge_class.to_sym) { raise ArgumentError, "Unknown badge size: #{badge_class}" }

    content_tag(:div, class: 'avatar', title: title) do
      content_tag(:div, class: ['kyc-badge', size_class, color].join(' ')) do
        elements = [label]

        if with_strike
          elements << content_tag(
            :span,
            '',
            class: 'kyc-badge-strike',
            aria: { hidden: true }
          )
        end

        safe_join(elements)
      end
    end
  end
end
