module Directories
  class Filter < ApplicationService
    attr_reader :initial_scope, :params

    def initialize(initial_scope = nil, **params)
      @initial_scope = initial_scope
      @params = params.with_indifferent_access
    end

    def call
      directories = relation.order(position: :asc)

      directories = Directories::AroundMeFilter.call(directories, geocoder_ip) if around_me? && geocoder_ip.present?

      directories = directories.by_query(query) if query.present?
      directories = directories.by_category(category) if category.present?
      directories = directories.by_coins(coins) if coins.present?

      Directories::ZoneFilter.call(directories, **params.except(:ip))
    end

    def geocoder_ip
      @geocoder_ip ||= begin
        results = Geocoder.search(ip, params: { fields: 'city,region,countryCode' })
        results.first
      end
    end

    private

    def relation
      @relation ||= initial_scope || Directory.enabled
    end

    def around_me?
      params[:around_me] == '1' && ip.present?
    end

    def query
      params[:query]
    end

    def category
      params[:category]
    end

    def coins
      params[:coins]
    end

    def ip
      params[:ip]
    end
  end
end
