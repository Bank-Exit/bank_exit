# This class acts as a model (not related to the database)
# to interact more elegantly with the global settings.
class Setting
  MAP_DEFAULT_THEME = 'light'.freeze
  MAP_DEFAULT_ZOOM = 5
  MAP_DEFAULT_LATITUDE = 45.7831
  MAP_DEFAULT_LONGITUDE = 3.0824
  MAP_DEFAULT_GESTURE_HANDLING = true
  MAP_DEFAULT_FIT_BOUNDS = false
  MAP_DEFAULT_COUNTRY = 'null'.freeze
  MAP_DEFAULT_CONTINENT = 'null'.freeze
  MAP_DEFAULT_COINS = 'null'.freeze
  MAP_DEFAULT_CLUSTERS = true
  MAP_DEFAULT_SHOW_ATTRIBUTION = true

  MAX_DEFAULT_DESCRIPTION_LENGTH = 255

  DARK_THEME_NAME = 'dark-bankexit'.freeze
end
