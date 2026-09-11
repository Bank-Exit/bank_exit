class SecureCacheStore < Geocoder::CacheStore::Generic
  def write(query, value)
    key = generate_cache_key(query)
    super(key, value)
  end

  def read(query)
    key = generate_cache_key(query)
    super(key)
  end

  def remove(query)
    key = generate_cache_key(query)
    super(key)
  end

  private

  def generate_cache_key(query)
    "geocoder:#{Digest::SHA256.hexdigest(query.to_s)}"
  end
end

Geocoder.configure(
  lookup: :nominatim,
  ip_lookup: :ipapi_com,
  http_headers: {
    'User-Agent' => 'Bank-Exit/2.x (sortiedebanque@tutamail.com)'
  },
  use_https: true,
  timeout: 30,
  cache: SecureCacheStore.new(Rails.cache, {}),
  cache_options: {
    expiration: 10.minutes
  }
)
