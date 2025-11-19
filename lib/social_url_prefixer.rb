# A service that normalizes and cleans social media URLs.
#
# Features:
# - Adds https:// if missing
# - Removes all unnecessary query parameters
# - Keeps essential parameters for specific networks
# - Rewrites twitter.com → x.com
# - Session and Signal are kept as plain handles, no URL generation
#
class SocialUrlPrefixer
  SOCIAL_PREFIXES = {
    'facebook' => 'https://facebook.com/',
    'x' => 'https://x.com/',
    'instagram' => 'https://instagram.com/',
    'youtube' => 'https://youtube.com/',
    'tiktok' => 'https://tiktok.com/@',
    'telegram' => 'https://t.me/',
    'matrix' => 'https://matrix.to/#/',
    'jabber' => 'xmpp:',
    'linkedin' => 'https://linkedin.com/in/',
    'tripadvisor' => 'https://tripadvisor.com/Profile/',
    'odysee' => 'https://odysee.com/@',
    'crowdbunker' => 'https://crowdbunker.com/@',
    'francelibretv' => 'https://francelibre.tv/@',
    'nostr' => 'https://njump.to/'
  }.freeze

  EXTRA_DOMAINS = {
    'youtube' => %w[youtu.be],
    'x' => %w[twitter.com]
  }.freeze

  ESSENTIAL_PARAMS = {
    'facebook' => %w[id],
    'youtube' => %w[v]
  }.freeze

  def self.call(platform, value)
    return if value.blank?

    platform = platform.to_s.downcase
    value    = value.to_s.strip

    # Special: Session and Signal are always plain handles
    return clean_handle(value) if %w[session signal].include?(platform)

    prefix = SOCIAL_PREFIXES[platform]

    # Already a URL
    return normalize_existing_url(platform, value) if url_like?(value)

    # Plain handle
    handle = clean_handle(value)
    return "#{prefix}#{handle}" if prefix

    handle
  end

  def self.clean_handle(value)
    value = value.strip.delete_prefix('@')
    # remove any GET parameters or fragments
    value.split(/[?#]/).first
  end

  def self.url_like?(value)
    return false if value.blank?
    return true if %r{^(https?:)?//}.match?(value)

    known_domains.any? { |domain| value.downcase.include?(domain) }
  end

  def self.known_domains
    @known_domains ||= begin
      domains = SOCIAL_PREFIXES.values.filter_map do |prefix|
        URI(prefix).host
      rescue URI::InvalidURIError
        nil
      end
      domains.concat(EXTRA_DOMAINS.values.flatten)
      domains.compact.uniq
    end
  end

  def self.normalize_existing_url(platform, url)
    url = "https://#{url}" unless %r{^(https?:)?//}.match?(url)
    uri = begin
      URI.parse(url)
    rescue StandardError
      nil
    end
    return url unless uri&.host

    # Rewrite Twitter → X
    uri.host = 'x.com' if uri.host == 'twitter.com'

    case platform
    when 'facebook', 'youtube'
      clean_url_with_essential_params(platform, uri)
    else
      # Generic networks: remove query parameters
      path = uri.path.sub(%r{/$}, '')
      "https://#{uri.host}#{path}"
    end
  end

  def self.clean_url_with_essential_params(platform, uri)
    essential = ESSENTIAL_PARAMS[platform] || []
    params    = CGI.parse(uri.query.to_s)
    filtered  = params.slice(*essential)

    query_str = filtered.map { |k, v| "#{k}=#{v.first}" }.join('&')
    host      = uri.host
    path      = uri.path.sub(%r{/$}, '')

    result = "https://#{host}#{path}"
    result += "?#{query_str}" unless query_str.empty?
    result
  end
end
