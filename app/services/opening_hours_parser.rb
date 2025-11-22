class OpeningHoursParser < ApplicationService
  attr_reader :opening_hours

  # @param opening_hours [String] the raw string value
  # @example Mo-Fr 07:00-21:30; Sa-Su 09:00-22:00
  def initialize(opening_hours)
    @opening_hours = opening_hours
  end

  # @return [Array<String>] formatted list of rules
  def call
    return [I18n.t('opening_hours.by_appointment')] if opening_hours == '"by appointment"'

    rules = cleaned_opening_hours.split(';')

    rules.map do |rule|
      raw_days, raw_hours = rule.split

      days = raw_days&.split('-') # Mo-Fr
      hours_ranges = raw_hours&.split(',') # 10:00-14:00,15:00-19:00

      days_str = if days.many?
                   days.map do |day|
                     days_by_prefix(day)
                   end.join(" #{I18n.t('to')} ")
                 else
                   days_by_prefix(days.first)
                 end

      hours_str = [I18n.t('from')]
      hours_ranges.map.with_index do |range, range_index|
        hours = range.split('-') # 10:00-14:00

        hours.each_with_index do |hour, index|
          hours_str << hour
          hours_str << I18n.t('to') if index.zero?
        end

        hours_str << I18n.t('and') if range_index.zero? && hours_ranges.many?
      end

      "#{days_str} #{hours_str.join(' ')}"
    end
  rescue I18n::MissingTranslationData => _e
    [opening_hours]
  end

  private

  def days_by_prefix(prefix)
    value = I18n.t(prefix.downcase)

    raise I18n::MissingTranslationData.new(I18n.locale, prefix.downcase) if value.include?('Translation missing')

    value
  end

  # Remove and clean value
  def cleaned_opening_hours
    @cleaned_opening_hours ||= opening_hours
                               .gsub('; PH off', '')
                               .gsub('PH,', '')
                               .gsub('; ', ';')
                               .gsub(' ;', ';')
                               .gsub(', ', ',')
  end
end
