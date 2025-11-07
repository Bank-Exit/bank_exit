module API
  class StatisticsPresenter < ::StatisticsPresenter
    private

    def merchants_monero_by_country
      base_merchants
        .monero
        .group(:country)
        .count
        .map do |iso, count|
          {
            iso: iso,
            continent: COUNTRY_TO_CONTINENT[iso.to_s.upcase],
            flag: ISO3166::Country[iso].emoji_flag,
            name: pretty_country_html(iso, show_flag: false),
            count: count
          }
        end.compact_blank
    end

    def merchants_june_by_country
      base_merchants
        .june
        .group(:country)
        .count
        .map do |iso, count|
          {
            iso: iso,
            continent: COUNTRY_TO_CONTINENT[iso.to_s.upcase],
            flag: ISO3166::Country[iso].emoji_flag,
            name: pretty_country_html(iso, show_flag: false),
            count: count
          }
        end.compact_blank
    end

    def merchants_categories_podium
      base_merchants
        .group(:category)
        .order(count_all: :desc)
        .limit(3)
        .count
        .map do |k, v|
          {
            original_name: k,
            human_name: I18n.t(k, scope: :categories),
            count: v
          }
        end
    end
  end
end
