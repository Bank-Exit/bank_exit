class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  geocoded_by :label do |model, results|
    result = results.first

    next unless result

    model.street = result.street
    model.postcode = result.postal_code
    model.city = result.city
    model.country = result.country
    model.country_code = result.country_code
    model.latitude = result.latitude
    model.longitude = result.longitude
  end

  after_validation :geocode, if: :label_changed?
end

# == Schema Information
#
# Table name: addresses
# Database name: primary
#
#  id               :integer          not null, primary key
#  label            :string
#  house_number     :string
#  street           :string
#  postcode         :string
#  city             :string
#  country          :string
#  country_code     :string
#  latitude         :float
#  longitude        :float
#  addressable_type :string           not null
#  addressable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_addresses_on_addressable             (addressable_type,addressable_id)
#  index_addresses_on_latitude                (latitude)
#  index_addresses_on_latitude_and_longitude  (latitude,longitude)
#  index_addresses_on_longitude               (longitude)
#
