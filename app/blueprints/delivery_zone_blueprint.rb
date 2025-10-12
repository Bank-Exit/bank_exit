class DeliveryZoneBlueprint < Blueprinter::Base
  field :mode, name: :name
  field :value
  field :city_name
  field :department_code
  field :region_code
  field :country_code
  field :continent_code
end
