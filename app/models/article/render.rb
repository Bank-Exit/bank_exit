class Article
  class Render
    attr_reader :partial, :template, :pdf, :caption, :iframe

    def initialize(partial: nil, template: nil, pdf: nil, caption: nil, iframe: nil)
      @partial = partial
      @template = template
      @pdf = pdf
      @caption = caption
      @iframe = iframe&.with_indifferent_access
    end

    def partial?
      partial.present?
    end

    def template?
      template.present?
    end

    def pdf?
      pdf.present?
    end

    def caption?
      caption.present?
    end

    def iframe?
      return false unless iframe

      iframe[:url].present?
    end
  end
end
