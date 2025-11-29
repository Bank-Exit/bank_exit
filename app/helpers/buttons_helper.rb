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

  def create_link_to(link, label: t('create'), klass: 'btn btn-sm btn-success', turbo_confirm: t('create_confirm'))
    link_to link, class: klass, data: { turbo_method: :post, turbo_confirm: turbo_confirm } do
      if block_given?
        yield
      else
        concat label
        concat lucide_icon('circle-plus', class: 'inline-flex ml-1 w-4')
      end
    end
  end

  def show_link_to(link, label: t('see'), klass: 'btn btn-sm btn-info', data: {}, blank: false)
    link_to link, class: klass, data: data, target: ('_blank' if blank) do
      if block_given?
        yield
      else
        concat label
        concat lucide_icon('eye', class: 'inline-flex ml-1 w-4')
      end
    end
  end

  def edit_link_to(link, label: t('edit'), klass: 'btn btn-sm btn-warning', data: {})
    link_to link, class: klass, data: data do
      concat label
      concat lucide_icon('pencil', class: 'inline-flex ml-1 w-4')
    end
  end

  def update_link_to(link, label: t('update'), klass: 'btn btn-sm btn-success', turbo_confirm: t('update_confirm'))
    link_to link, class: klass, data: { turbo_method: :patch, turbo_confirm: turbo_confirm } do
      concat label
      concat lucide_icon('pencil', class: 'inline-flex ml-1 w-4')
    end
  end

  def destroy_link_to(link, label: t('destroy'), klass: 'btn btn-sm btn-error', turbo_confirm: t('destroy_confirm'))
    link_to link, class: klass, data: { turbo_method: :delete, turbo_confirm: turbo_confirm } do
      concat label
      concat lucide_icon('trash', class: 'inline-flex ml-1 w-4')
    end
  end
end
