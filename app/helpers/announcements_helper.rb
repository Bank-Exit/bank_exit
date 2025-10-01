module AnnouncementsHelper
  def announcement_color_by_mode(mode)
    case mode
    when 'success' then 'badge-success'
    when 'info' then 'badge-info'
    when 'warning' then 'badge-warning'
    when 'error' then 'badge-error'
    else
      ''
    end
  end
end
