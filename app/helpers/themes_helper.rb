module ThemesHelper
  def find_themes(date = Date.current)
    themes =
      case date.strftime('%m-%d')
      # December 10 to January 10
      when '12-10'..'12-31', '01-01'..'01-10'
        {
          light: :christmas,
          dark: :dark_christmas
        }
      # October 30 to November 1st
      when '10-30', '10-31', '11-01'
        {
          dark: :halloween
        }
      else
        {}
      end

    themes[:light] ||= Setting::LIGHT_THEME_NAME
    themes[:dark] ||= Setting::DARK_THEME_NAME
    themes
  end
end
