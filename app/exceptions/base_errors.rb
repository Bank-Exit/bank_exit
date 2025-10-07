class BaseErrors < StandardError
  attr_reader :options

  def initialize(message = nil, **options)
    @options = options
    super(message)
  end

  def message
    I18n.t(class_name, scope: i18n_scope, **options)
  end

  def i18n_scope
    'exceptions'
  end

  private

  def class_name
    self.class.name.underscore.tr('/', '.')
  end
end
