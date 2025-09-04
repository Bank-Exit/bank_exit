xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'

xml.gpx(
  version: '1.1',
  creator: t('seo.default.title'),
  xmlns: 'http://www.topografix.com/GPX/1/1',
  'xmlns:gpxx' => 'http://www.garmin.com/xmlschemas/GpxExtensions/v3'
) do
  xml.metadata do
    xml.name merchant_metadata_title(@coins, @category, @continent, @country, @query)
    xml.desc t('.description')
    xml.time Time.now.utc.iso8601(6)

    xml.author do
      xml.name t('seo.default.title')
      xml.email merchant_metadata_email
      xml.link(href: root_url) do
        xml.text t('seo.default.title')
        xml.type 'text/html'
      end
    end

    xml.copyright(author: t('seo.default.title')) do
      xml.year "2022 - #{Date.current.year}"
      xml.license 'https://www.gnu.org/licenses/agpl-3.0.html'
    end

    xml.link(href: maps_url) do
      xml.text t('application.nav.menu.map')
      xml.type 'text/html'
    end

    min_lat, max_lat = @merchants.map(&:latitude).minmax
    min_lon, max_lon = @merchants.map(&:longitude).minmax
    xml.bounds(minlat: min_lat, minlon: min_lon, maxlat: max_lat, maxlon: max_lon)
  end

  @merchants.each do |merchant|
    xml.wpt(lat: merchant.latitude, lon: merchant.longitude) do
      xml.name "#{merchant_icon(merchant)} #{merchant.name}"
      xml.desc merchant_description(merchant)
      xml.type I18n.t(merchant.category, scope: 'categories', default: merchant.category)
      xml.sym merchant.monero? ? 'Star' : 'Bank'

      xml.extensions do
        xml.tag!('gpxx:WaypointExtension') do
          xml.tag!('gpxx:DisplayMode', 'SymbolAndName')
        end
      end
    end
  end
end
