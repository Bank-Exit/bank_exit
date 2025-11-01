module JSONHelper
  def json_highlight(json)
    JSONHighlighter.new(json).colorize
  end

  def diffy_json(before_json, after_json, highlight: true)
    if highlight
      before_colored = json_highlight(before_json)
      after_colored = json_highlight(after_json)
    else
      before_colored = JSON.pretty_generate(JSON.parse(before_json))
      after_colored = JSON.pretty_generate(JSON.parse(after_json))
    end

    diff_html = Diffy::Diff.new(
      before_colored,
      after_colored,
      include_plus_and_minus_in_html: true
    ).to_s(:html)

    CGI.unescapeHTML(diff_html)
  end
end
