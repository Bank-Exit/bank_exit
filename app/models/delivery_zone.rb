class DeliveryZone < ApplicationRecord
  enum :mode,
       {
         city: 0,
         department: 1,
         region: 2,
         country: 3,
         continent: 4,
         world: 5
       },
       validate: true

  belongs_to :deliverable, polymorphic: true

  geocoded_by :value do |model, results|
    result = results.first

    next unless result

    model.city_name = result.city || result.town
    model.department_code = result.data.dig('address', 'ISO3166-2-lvl6')
    model.region_code = result.data.dig('address', 'ISO3166-2-lvl4')
    model.country_code = result.country_code&.upcase
    model.continent_code = COUNTRY_TO_CONTINENT[model.country_code.to_s.upcase]

    # Fallback to default value for department
    # and region if Geocoder did not return
    # accurate data.
    if model.city?
      model.city_name ||= model.value
      model.department_code ||= model.value
      model.region_code ||= model.value
    end
  end

  # Prevent call to geocoder using internal
  # mapping informations.
  before_validation :assign_region_country_and_continent, if: :region?
  before_validation :assign_country_and_continent, if: :country?
  before_validation :assign_continent, if: :continent?

  after_validation :geocode, if: :geocode?

  scope :enabled, -> { where(enabled: true) }

  validates :value, presence: true, unless: :world?

  private

  def assign_region_country_and_continent
    self.region_code = value
    self.country_code = 'FR'
    self.continent_code = continent_for_country_code(country_code)
  end

  def assign_country_and_continent
    self.country_code = value
    self.continent_code = continent_for_country_code(country_code)
  end

  def assign_continent
    self.continent_code = value
  end

  def geocode?
    (city? || department?) && value_changed?
  end

  def continent_for_country_code(country_code)
    COUNTRY_TO_CONTINENT[country_code.to_s.upcase]
  end
end

# == Schema Information
#
# Table name: delivery_zones
# Database name: primary
#
#  id               :integer          not null, primary key
#  mode             :integer
#  value            :string
#  city_name        :string
#  department_code  :string
#  region_code      :string
#  country_code     :string
#  enabled          :boolean          default(TRUE), not null
#  deliverable_type :string           not null
#  deliverable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  continent_code   :string
#
# Indexes
#
#  index_delivery_zones_on_city_name        (city_name)
#  index_delivery_zones_on_continent_code   (continent_code)
#  index_delivery_zones_on_country_code     (country_code)
#  index_delivery_zones_on_deliverable      (deliverable_type,deliverable_id)
#  index_delivery_zones_on_department_code  (department_code)
#  index_delivery_zones_on_region_code      (region_code)
#
