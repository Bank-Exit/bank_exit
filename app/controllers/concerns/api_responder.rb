module APIResponder
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  def render_collection(collection, pagy:, blueprint: nil, type: nil, **)
    resource_class = collection.class.to_s.split('::').first.constantize

    raise ArgumentError, 'Cannot infer type and blueprint from empty collection' if resource_class.nil? && (blueprint.nil? || type.nil?)

    blueprint ||= default_blueprint_for(resource_class)
    type      ||= default_type_for(resource_class)

    render json: {
      data: collection.map { |record| serialize_resource(record, blueprint, type: type, **) },
      meta: pagination_meta(pagy),
      links: pagy_jsonapi_links(pagy, absolute: true)
    }
  end

  def render_resource(resource, blueprint: nil, type: nil, **)
    resource_class = resource.class

    blueprint ||= default_blueprint_for(resource_class)
    type      ||= default_type_for(resource_class)

    render json: {
      data: serialize_resource(resource, blueprint, type: type, **),
      links: {
        self: request.url
      }
    }
  end

  private

  def serialize_resource(record, blueprint, type:, **)
    {
      id: record.is_a?(Merchant) ? record.identifier : record.id,
      type: type.to_s,
      attributes: blueprint.render_as_hash(record, **)
    }
  end

  def pagination_meta(pagy)
    {
      page: pagy.page,
      count: pagy.count,
      pages: pagy.pages,
      per_page: pagy.vars[:limit]
    }
  end

  def default_type_for(klass)
    klass.name.underscore.pluralize.dasherize
  end

  def default_blueprint_for(klass)
    "#{klass.name}Blueprint".constantize
  rescue NameError
    raise ArgumentError, "Blueprint not found for #{klass.name}"
  end
end
