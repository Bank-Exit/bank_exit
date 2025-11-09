module Themable
  extend ActiveSupport::Concern

  included do
    before_action :set_theme_finder
  end

  private

  def set_theme_finder
    @themes_finder = ThemesFinder.new(forced_theme: theme)
    @themes = @themes_finder.call
  end

  def theme
    params[:theme]
  end
end
