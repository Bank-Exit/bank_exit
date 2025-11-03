module JSONHelper
  def json_highlight(json)
    JSONHighlighter.new(json).colorize
  end
end
