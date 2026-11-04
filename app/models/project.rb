class Project < Article
  attribute :image, :string

  def banner
    super || 'banner-projects'
  end

  def cover?
    Rails.root.join("app/assets/images/#{cover}").exist?
  end

  def cover
    extension = 'jpg'
    extension = 'png' if crypto_box? || libre_monero?

    "projects/#{identifier}/cover.#{extension}"
  end

  def logo?
    cover?
  end

  def logo
    cover
  end

  private

  def crypto_box?
    identifier == 'sticker'
  end

  def libre_monero?
    identifier == 'libremonero'
  end
end
