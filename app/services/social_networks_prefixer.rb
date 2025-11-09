class SocialNetworksPrefixer < ApplicationService
  attr_reader :properties

  def initialize(properties)
    @properties = properties.with_indifferent_access
  end

  def contact_session
    properties['contact:session']
  end

  def contact_signal
    properties['contact:signal']
  end

  def contact_matrix
    properties['contact:matrix']
  end

  def contact_jabber
    properties['contact:jabber']
  end

  def contact_telegram
    value = properties['contact:telegram']

    return unless value

    value = value.split('?').first
    return value if value.starts_with?('https://t.me/')

    "https://t.me/#{value.delete_prefix('@')}"
  end

  def contact_facebook
    value = properties['contact:facebook']

    return unless value

    value = value.split('?').first
    return value if value.include?('facebook.com/')

    "https://facebook.com/#{value.delete_prefix('@')}"
  end

  def contact_instagram
    value = properties['contact:instagram']

    return unless value

    value = value.split('?').first
    return value if value.include?('instagram.com/')

    "https://instagram.com/#{value.delete_prefix('@')}"
  end

  def contact_twitter
    value = properties['contact:twitter']

    return unless value

    value = value.split('?').first
    return value if value.include?('twitter.com/') || value.include?('x.com/')

    "https://x.com/#{value.delete_prefix('@')}"
  end

  def contact_youtube
    value = properties['contact:youtube']

    return unless value

    value = value.split('?').first
    return value if value.include?('youtube.com/')

    "https://youtube.com/#{value.delete_prefix('@')}"
  end

  def contact_tiktok
    value = properties['contact:tiktok']

    return unless value

    value = value.split('?').first
    return value if value.include?('tiktok.com/')

    "https://tiktok.com/#{value.delete_prefix('@')}"
  end

  def contact_linkedin
    value = properties['contact:linkedin']

    return unless value

    value = value.split('?').first
    return value if value.include?('linkedin.com/')

    "https://linkedin.com/#{value.delete_prefix('@')}"
  end

  def contact_tripadvisor
    value = properties['contact:tripadvisor']

    return unless value

    value = value.split('?').first
    return value if value.include?('tripadvisor.com/')

    "https://tripadvisor.com/#{value.delete_prefix('@')}"
  end

  def contact_odysee
    value = properties['contact:odysee']

    return unless value

    value = value.split('?').first
    return value if value.include?('odysee.com/')

    "https://odysee.com/#{value.delete_prefix('@')}"
  end

  def contact_crowdbunker
    value = properties['contact:crowdbunker']

    return unless value

    value = value.split('?').first
    return value if value.include?('crowdbunker.com/')

    value.prepend('@') unless value.starts_with?('@')
    "https://crowdbunker.com/#{value}"
  end

  def contact_francelibretv
    value = properties['contact:francelibretv']

    return unless value

    value = value.split('?').first
    return value if value.include?('francelibre.tv/')

    value.prepend('chaine/') unless value.include?('chaine/')
    "https://francelibre.tv/#{value.delete('@')}"
  end
end
