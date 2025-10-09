class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if value.include?('@')
      record.errors.add(attribute, options[:message] || :invalid_url)
      return
    end

    uri = parse_uri(value)
    return unless uri.nil? || uri.host.blank? || !valid_tld?(uri.host)

    record.errors.add(attribute, options[:message] || :invalid_url)
  end

  private

  def parse_uri(value)
    value = "http://#{value}" unless %r{\Ahttps?://}i.match?(value)
    URI.parse(value)
  rescue URI::InvalidURIError
    nil
  end

  def valid_tld?(host)
    parts = host.to_s.split('.')

    tld = parts.last
    tld.present? && tld.match?(/\A[a-z]{2,8}\z/i) && parts.size > 1
  end
end
