module IconsHelper
  def status_icon(type = :success)
    base_class = 'status status-lg flex items-center justify-center w-5 h-5 rounded-full'

    case type
    when :error
      icon = lucide_icon('x', class: 'text-error-content')
      type_class = 'status-error'
    when :success
      icon = lucide_icon('check', class: 'text-success-content')
      type_class = 'status-success'
    end

    content_tag(
      :div, icon,
      class: "#{base_class} #{type_class}",
      aria: { label: 'status' }
    )
  end
end
