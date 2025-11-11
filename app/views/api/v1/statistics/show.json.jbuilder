json.data do
  json.merchants do
    json.totals do
      json.bitcoin @coins_statistics[:bitcoin_world].count
      json.monero @coins_statistics[:monero_world].count
      json.june @coins_statistics[:june_world].count
    end

    json.new do
      json.today @merchants_statistics[:today].count
      json.yesterday @merchants_statistics[:yesterday].count
    end

    json.last_update @last_checked_at

    json.categories do
      json.top @categories_statistics[:podium_categories]
    end

    json.by_countries do
      json.monero @countries_statistics[:monero_by_country]
      json.june @countries_statistics[:june_by_country]
    end
  end

  json.directories do
    json.total_count @directories_statistics[:enabled].count
  end
end

json.links do
  json.self request.url
end
