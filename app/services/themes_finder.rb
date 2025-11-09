class ThemesFinder < ApplicationService
  THEMES = {
    christmas: {
      light: :christmas,
      dark: :dark_christmas
    },
    halloween: {
      dark: :halloween
    }
  }.freeze

  attr_reader :date, :forced_theme

  def initialize(date = Date.current, forced_theme: nil)
    @date = date.strftime('%m-%d')
    @forced_theme = forced_theme&.to_sym
  end

  def call
    themes = if christmas_time?
               THEMES[:christmas]
             elsif halloween_time?
               THEMES[:halloween]
             else
               {}
             end

    themes[:light] ||= Setting::LIGHT_THEME_NAME
    themes[:dark] ||= Setting::DARK_THEME_NAME
    themes
  end

  def christmas_time?
    return true if forced_theme == :christmas

    ff_enabled = ENV.fetch('FF_SNOWFLAKES_ENABLED', 'true') == 'true'
    return false unless ff_enabled

    @christmas_time ||=
      ('12-10'..'12-31').cover?(date) ||
      ('01-01'..'01-10').cover?(date)
  end

  def halloween_time?
    return true if forced_theme == :halloween

    @halloween_time ||= %w[10-30 10-31 11-01].include?(date)
  end
end
