class OverpassAPI
  include HTTParty

  default_timeout 360
  base_uri 'https://overpass-api.de'

  # API call that returns XBT, lightning, XMR and XG1 results.
  # XBT and lightning are scoped to West Europe only for now.
  def fetch_merchants
    self.class.get('/api/interpreter', query: {
      data: <<-OVERPASSQL
        [out:json][timeout:360];

        (
          area(id:3602202162); // France
          area(id:3601311341); // Spain
          area(id:3600051701); // Swiss
          area(id:3600295480); // Portugal
          area(id:3600365331); // Italy
          area(id:3600051477); // Germany
          area(id:3600052411); // Belgium
          area(id:3606038068); // Great Britain
          area(id:3600062273); // Ireland
          area(id:3600050046); // Denmark
          area(id:3601059668); // Norway
          area(id:3600054224); // Finland
          area(id:3600052822); // Sweden
          area(id:3600016239); // Austria
          area(id:3600049715); // Poland
          area(id:3600214885); // Croatia
          area(id:3600192307); // Greece
          area(id:3600021335); // Hungary
          area(id:3600090689); // Romania
          area(id:3600060199); // Ukraine
          area(id:3600058974); // Moldova
          area(id:3600299133); // Iceland
          area(id:3602171347); // Luxembourg
          area(id:3600009407); // Andorra
          area(id:3601124039); // Monaco
          area(id:3603263726); // Cyprus
          area(id:3600365307); // Malta
          area(id:3601428125); // Canada
          area(id:3600148838); // United States
          area(id:3600114686); // Mexico
          area(id:3600307833); // Cuba
          area(id:3600080500); // Australia
          area(id:3600556706); // New Zealand
          area(id:3600059470); // Brazil
          area(id:3600286393); // Argentina
          area(id:3600167454); // Chile
          area(id:3600288247); // Peru
          area(id:3600287077); // Paraguay
          area(id:3600287072); // Uruguay
          area(id:3600252645); // Bolivia
          area(id:3600192798); // Kenya
          area(id:3600195271); // Zambia
          area(id:3600087565); // South Africa
        )->.areaSet;

        (
          // Nodes
          node["currency:XBT"="yes"](area.areaSet);
          node["payment:lightning"="yes"](area.areaSet);
          node["currency:XMR"="yes"];
          node["currency:XG1"="yes"];
          node["currency:June"="yes"];

          // Ways
          way["currency:XBT"="yes"](area.areaSet);
          way["payment:lightning"="yes"](area.areaSet);
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
