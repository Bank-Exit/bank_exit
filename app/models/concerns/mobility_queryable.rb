# @!macro [new] queryable_concern
#   @!method by_query(query)
#   @param query [String] The search term to look for in translated fields.
#   @return [ActiveRecord::Relation] A relation with matching translated records.
#
#   Dynamically searches across translated attributes using SQL `LIKE` conditions.
#   Works with the Mobility `:key_value` backend by querying translation tables
#   (`mobility_string_translations` and `mobility_text_translations`) instead of model columns.
#
#   This scope allows searching translated fields (`name`, `description`, etc.) with partial
#   matches using SQL `LIKE`, while filtering properly by `locale`, `key`, and `translatable_type`.
#
#   Example:
#     # In a model:
#     #
#     #   class Directory < ApplicationRecord
#     #     extend Mobility
#     #     include MobilityQueryable
#     #
#     #     translates :name, type: :string
#     #     translates :description, type: :text
#     #
#     #     queryable_by name: :string, description: :text
#     #   end
#     #
#     # Usage:
#     #
#     #   Directory.by_query("consulting")
#     #
#     # This generates a SQL query that searches the translated `name` and `description`
#     # fields (in the current locale) for partial matches.
#
# @note
#   This concern is specifically designed for the Mobility `:key_value` backend.
#   Other backends (e.g., `table`, `jsonb`) store translations differently and
#   may require different querying strategies.
#
# @example Declaring searchable translated fields
#   queryable_by name: :string, description: :text
#
# @see https://mobility.rbcas.com Mobility gem documentation
module MobilityQueryable
  extend ActiveSupport::Concern

  included do
    class_attribute :queryable_attributes_with_types, instance_accessor: false, default: {}
  end

  class_methods do
    def queryable_by(attributes_with_types)
      self.queryable_attributes_with_types ||= {}

      attributes_with_types.each do |attr, type|
        raise ArgumentError, "Attribute #{attr} is not a translated Mobility attribute" unless mobility_attributes.include?(attr.to_s)

        raise ArgumentError, "Unsupported or missing type for attribute #{attr.inspect}" unless %i[string text].include?(type)

        self.queryable_attributes_with_types[attr] = type
      end

      klass = self

      scope :by_query, lambda { |query|
        return all if query.blank?

        locale = I18n.locale.to_s
        pattern = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"

        arel_model_table = klass.arel_table

        conditions = queryable_attributes_with_types.map do |attr, type|
          table_name =
            case type
            when :string
              :mobility_string_translations
            when :text
              :mobility_text_translations
            else
              raise ArgumentError, "Unsupported type #{type} for #{attr}"
            end

          arel_translation_table = Arel::Table.new(table_name)

          arel_model_table[:id].in(
            arel_translation_table
              .project(arel_translation_table[:translatable_id])
              .where(
                arel_translation_table[:translatable_type].eq(klass.name)
                  .and(arel_translation_table[:locale].eq(locale))
                  .and(arel_translation_table[:key].eq(attr.to_s))
                  .and(arel_translation_table[:value].matches(pattern))
              )
          )
        end

        where(conditions.reduce(:or))
      }
    end
  end
end
