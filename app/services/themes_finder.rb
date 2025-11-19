class ThemesFinder < ApplicationService
  THEMES = {
    christmas: {
      light: :christmas,
      dark: :dark_christmas
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
             else
               {}
             end

    themes[:light] ||= Setting::LIGHT_THEME_NAME
    themes[:dark] ||= Setting::DARK_THEME_NAME
    themes
  end

  def christmas_time?
    return true if forced_theme == :christmas
    return false if FeatureFlag.disabled?(:snowflakes)

    @christmas_time ||=
      ('12-10'..'12-31').cover?(date) ||
      ('01-01'..'01-10').cover?(date)
  end
end
