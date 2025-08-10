module DirectoriesHelper
  def directories_categories_select_helper
    I18n.t('directories_categories').map do |row|
      [row[1], row[0]]
    end
  end

  def directories_referer_path
    session[:directories_referer_url].presence || directories_path
  end

  def directories_as_grid?
    session[:directories_display] == 'grid'
  end
end
