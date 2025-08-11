class OSRMRouterAPI
  include HTTParty

  base_uri 'https://router.project-osrm.org'

  def calculate_itinerary(dep_lat, dep_long, arr_lat, arr_long, detailed_steps: false)
    coordinates = "#{dep_long},#{dep_lat};#{arr_long},#{arr_lat}"

    self.class.get("/route/v1/driving/#{coordinates}", query: {
      overview: :full,
      steps: detailed_steps,
      alternatives: false
    })
  end
end
