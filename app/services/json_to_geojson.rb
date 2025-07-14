# This service is responsible to convert a JSON structured file
# from Overpass API to a GeoJSON that is better understandable
# by Leaflet map.
class JSONToGeoJSON < ApplicationService
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def call
    geojson = {
      type: 'FeatureCollection',
      generator: "#{json['generator']} - Note: converted to GeoJSON by manual script",
      timestamp: json.dig('osm3s', 'timestamp_osm_base'),
      copyright: json.dig('osm3s', 'copyright'),
      features_count: elements.count,
      features: []
    }

    elements.each do |element|
      feature = case element['type']
                when 'node'
                  # Empty `node` associated to `way` elements
                  next if element['tags'].blank?

                  node_handler(element)
                when 'way'
                  # Way elements needs special treatment to get
                  # back the lat and lon of first associated node.
                  first_node_id = element['nodes'].first
                  first_node = elements.find { it['id'] == first_node_id }
                  way_handler(element, first_node)
                end

      geojson[:features] << feature
    end

    geojson.deep_stringify_keys
  end

  private

  def elements
    json['elements']
  end

  def node_handler(element)
    geometry = if element['geometry'].blank?
                 {
                   type: 'Point',
                   coordinates: [element['lon'], element['lat']]
                 }
               else
                 coordinates = element['geometry'].map do |coord|
                   [coord['lon'], coord['lat']]
                 end

                 {
                   type: 'Polygon',
                   coordinates: [coordinates]
                 }
               end

    {
      type: 'Feature',
      id: "#{element['type']}/#{element['id']}",
      properties: element['tags'],
      geometry: geometry
    }
  end

  def way_handler(element, node)
    {
      type: 'Feature',
      id: "#{element['type']}/#{element['id']}",
      properties: element['tags'],
      geometry: {
        type: 'Point',
        coordinates: [node['lon'], node['lat']]
      }
    }
  end
end
