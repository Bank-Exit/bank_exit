module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'flashes', partial: 'flashes'
  end

  def random_bg_hero_banner
    "bg-banner-#{rand(1..5)}"
  end

  def icon_for_category(category)
    MerchantIcon.call(category)
  end

  def select_options_for(klass, enum_name)
    enum = klass.send(enum_name)
    enum.keys.map { |k| [klass.human_enum_name(enum_name, k), k] }
  end

  def human_count(record_class, count)
    "#{content_tag(:strong, number_with_delimiter(count))} #{record_class.model_name.human(count: count)}"
  end

  def map_referer_path
    session[:map_referer_url].presence || maps_path
  end

  def logo_by_locale
    return 'logo.png' if I18n.locale == :fr

    'logo_EN.png'
  end

  # Find the corresponding flag associated to a
  # language code. Tweak the country if the language
  # is not linked to a flag directly.
  def emoji_by_locale(locale)
    locale = locale.to_s.upcase

    country = case locale
              when 'EN' then 'GB'
              else
                locale
              end

    ISO3166::Country[country].emoji_flag
  rescue StandardError
    nil
  end

  def clean_url(value)
    value = value.to_s
    return nil unless value.valid_encoding?

    value.split('?').first
         .delete_prefix('https://')
         .delete_prefix('http://')
         .delete_prefix('www.')
         .delete_suffix('/')
  end

  def france_debt_data_by_years
    {
      '1974' => 92,
      '1981' => 210,
      '1995' => 660,
      '2007' => 1210,
      '2012' => 1870,
      '2017' => 2260,
      '2025' => 3345
    }
  end

  def locales_select_helper
    I18n.available_locales.map do |locale|
      [
        "#{emoji_by_locale(locale)} #{Rails.configuration.i18n_human_languages[locale]}",
        locale
      ]
    end
  end

  # Rails' built-in `video_tag` helper does not support a `track` option for adding subtitles or captions.
  # This helper manually builds the <track> tags and appends them inside the generated <video> element.
  def video_with_tracks_tag(source, tracks = [], **)
    sources_html = Array(source).map do |src|
      tag.source(src: asset_path(src), type: "video/#{File.extname(src).delete('.')}")
    end

    tracks_html = tracks.map do |track|
      tag.track(
        **track,
        src: video_path("tracks/#{track[:src]}"),
        kind: :subtitles,
        label: Rails.configuration.i18n_human_languages[track[:srclang]]
      )
    end

    inner_html = safe_join(sources_html + tracks_html)

    content_tag(:video, inner_html, **)
  end

  def i18n_resource_name
    model_class = controller_path.classify.demodulize.singularize.constantize

    model_class.model_name.human(count: 2).capitalize
  end

  def video_embed(video)
    content_tag(:figure) do
      iframe = tag.iframe(
        nil,
        src: video[:url],
        class: 'rounded-box mx-auto w-full h-72 lg:w-3/4 lg:h-137.5 print:hidden',
        title: 'Video iframe'
      )

      caption = content_tag(:figcaption, class: 'text-center') do
        safe_join([
          content_tag(:span, video[:title], class: 'italic'),
          (content_tag(:span, l(video[:created_at].to_date), class: 'badge badge-primary badge-sm ml-1') if video[:created_at]),
          tag.br,
          link_to(video[:url], video[:url], target: '_blank', rel: 'noopener', class: 'link link-primary')
        ].compact)
      end

      safe_join([iframe, caption])
    end
  end
end
