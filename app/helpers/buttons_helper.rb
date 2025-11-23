module ButtonsHelper
  def back_link_to(link, label: t('back'), klass: 'btn btn-sm btn-neutral', data: {})
    link_to link, class: klass, data: data do
      concat lucide_icon('move-left', class: 'inline-flex mr-1 w-4')
      concat label
    end
  end

  def add_link_to(link, label: t('add'), klass: 'btn btn-sm btn-success', data: {})
    link_to link, class: klass, data: data do
      concat label
      concat lucide_icon('circle-plus', class: 'inline-flex ml-1 w-4')
    end
  end

  def edit_link_to(link, label: t('edit'), klass: 'btn btn-sm btn-warning', data: {})
    link_to link, class: klass, data: data do
      concat label
      concat lucide_icon('pencil', class: 'inline-flex ml-1 w-4')
    end
  end

  def destroy_link_to(link, label: t('destroy'), klass: 'btn btn-sm btn-error', data: { turbo_method: :delete, turbo_confirm: t('destroy_confirm') })
    link_to link, class: klass, data: data do
      concat label
      concat lucide_icon('trash', class: 'inline-flex ml-1 w-4')
    end
  end
end
