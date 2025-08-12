class OverpassAPI
  include HTTParty

  default_timeout 360
  base_uri 'https://overpass-api.de'

  # API call that returns XBT, lightning, XMR and XG1 results.
  def fetch_merchants
    self.class.get('/api/interpreter', query: {
      data: <<-OVERPASSQL
        [out:json][timeout:360];
        (
          // Nodes
          node["currency:XBT"="yes"];
          node["payment:lightning"="yes"];
          node["currency:XMR"="yes"];
          node["currency:XG1"="yes"];
          node["currency:June"="yes"];

          // Ways
          way["currency:XBT"="yes"];
          way["payment:lightning"="yes"];
          way["currency:XMR"="yes"];
          way["currency:XG1"="yes"];
          way["currency:June"="yes"];
        );

        out body;
        >;
        out skel qt;
      OVERPASSQL
    })
  end
end
