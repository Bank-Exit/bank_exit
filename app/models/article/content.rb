class Article
  class Content
    attr_reader :title, :body, :mode, :url

    def initialize(title: nil, body: [], mode: nil, render: {}, figure: [], url: nil)
      @title = title
      @body = body
      @mode = mode
      @render = render.with_indifferent_access
      @figure = figure
      @url = url
    end

    delegate :video?, to: :figure, allow_nil: true

    def title?
      title.present?
    end

    def body?
      body.present?
    end

    def mode?
      mode&.in?(%w[default success warning info error base-300 intro])
    end

    def render
      return unless render?

      Article::Render.new(
        **@render.slice(:partial, :template, :pdf, :caption, :iframe).symbolize_keys
      )
    end

    def render?
      @render.present?
    end

    def figure
      return unless figure?

      @figure.map do |figure|
        Article::Figure.new(
          **figure.with_indifferent_access.slice(:image, :video, :caption, :klass).symbolize_keys
        )
      end
    end

    def figure?
      @figure.present?
    end

    def url?
      @url.present?
    end
  end
end
