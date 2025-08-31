class Article
  class Figure
    attr_reader :image, :caption, :url, :klass

    def initialize(image: nil, video: {}, caption: nil, url: nil, klass: nil)
      @image = image
      @video = video.with_indifferent_access
      @caption = caption
      @url = url
      @klass = klass
    end

    def image?
      @image.present?
    end

    def video?
      @video.present?
    end

    def video
      return unless video?

      Article::Video.new(
        **@video.slice(:title, :url, :created_at).symbolize_keys
      )
    end

    def caption?
      caption.present?
    end

    def url?
      url.present?
    end

    def klass?
      klass.present?
    end
  end
end
