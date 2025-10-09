module Directories
  class ZoneFilter < ApplicationService
    attr_reader :relation, :filter_mode, :filter_value, :is_world_filter

    def initialize(relation, **params)
      @relation = relation
      extract_filter_from(params)
    end

    def call
      return filter_by_world if is_world_filter
      return relation if filter_mode.blank? || filter_value.blank?

      match_conditions = build_hierarchical_match_conditions
      return relation.none if match_conditions.empty?

      sql, sql_params = build_sql_and_params(match_conditions)

      Rails.logger.debug { "SQL Query: #{sql}" }
      Rails.logger.debug { "SQL Params: #{sql_params}" }

      relation.includes(:delivery_zones)
              .joins(:delivery_zones)
              .where(delivery_zones: { enabled: true })
              .where(sql, sql_params)
    end

    private

    def extract_filter_from(params)
      @is_world_filter = ActiveModel::Type::Boolean.new.cast(params[:world])

      valid_modes = DeliveryZone.modes.keys.map(&:to_sym) - [:world]
      matched_filter = params.slice(*valid_modes).compact_blank.first

      @filter_mode, @filter_value =
        matched_filter ? [matched_filter[0].to_s, matched_filter[1].to_s.strip] : [nil, nil]
    end

    def filter_by_world
      Rails.logger.debug { 'Applying world filter only' }
      relation.includes(:delivery_zones)
              .joins(:delivery_zones)
              .where(delivery_zones: { mode: :world, enabled: true })
    end

    def build_hierarchical_match_conditions
      mode = filter_mode.to_sym

      unless mode.in?(%i[country continent])
        location = Geocoder.search(filter_value).first
        return [] unless location

        country_code    = location.country_code&.upcase
        region_code     = location.data.dig('address', 'ISO3166-2-lvl4') || filter_value
        department_code = location.data.dig('address', 'ISO3166-2-lvl6') || filter_value
        city_name       = location.city || location.town || filter_value
        continent_code = COUNTRY_TO_CONTINENT[country_code]
      end

      conditions = []

      case mode
      when :city
        conditions << { mode: DeliveryZone.modes['city'], column: :city_name, value: city_name } if city_name.present?
        conditions << { mode: DeliveryZone.modes['department'], column: :department_code, value: department_code } if department_code.present?
        conditions << { mode: DeliveryZone.modes['region'], column: :region_code, value: region_code } if region_code.present?
        if country_code.present?
          conditions << { mode: DeliveryZone.modes['country'], column: :country_code, value: country_code }
          conditions << { mode: DeliveryZone.modes['continent'], column: :continent_code, value: continent_code }
        end
      when :department
        conditions << { mode: DeliveryZone.modes['department'], column: :department_code, value: department_code } if department_code.present?
        conditions << { mode: DeliveryZone.modes['region'], column: :region_code, value: region_code } if region_code.present?
        if country_code.present?
          conditions << { mode: DeliveryZone.modes['country'], column: :country_code, value: country_code }
          conditions << { mode: DeliveryZone.modes['continent'], column: :continent_code, value: continent_code }
        end
      when :region
        conditions << { mode: DeliveryZone.modes['region'], column: :region_code, value: region_code } if region_code.present?
        if country_code.present?
          conditions << { mode: DeliveryZone.modes['country'], column: :country_code, value: country_code }
          conditions << { mode: DeliveryZone.modes['continent'], column: :continent_code, value: continent_code }
        end
      when :country
        country_code = filter_value
        continent_code = COUNTRY_TO_CONTINENT[country_code]

        conditions << { mode: DeliveryZone.modes['country'], column: :country_code, value: country_code }
        conditions << { mode: DeliveryZone.modes['continent'], column: :continent_code, value: continent_code }
      when :continent
        continent_code = filter_value

        conditions << { mode: DeliveryZone.modes['continent'], column: :continent_code, value: continent_code } if continent_code.present?
      end

      # Always add world fallback
      conditions << { mode: DeliveryZone.modes['world'], column: :value, value: '' }

      log_matching_conditions(conditions)

      conditions
    end

    def log_matching_conditions(conditions)
      conditions.each do |condition|
        mode_name = DeliveryZone.modes.key(condition[:mode].to_i).to_s
        value = condition[:value] || 'nil'
        Rails.logger.debug { "Matching condition: Mode = #{mode_name}, Value = #{value}" }
      end
    end

    def build_sql_and_params(conditions)
      sql_parts = []
      params = {}

      conditions.each_with_index do |cond, i|
        mode_key  = :"mode_#{i}"
        value_key = :"value_#{i}"
        column    = cond[:column]

        sql_parts << "(delivery_zones.mode = :#{mode_key} AND delivery_zones.#{column} = :#{value_key})"

        params[mode_key] = cond[:mode]
        params[value_key] = cond[:value]
      end

      [sql_parts.join(' OR '), params]
    end
  end
end
