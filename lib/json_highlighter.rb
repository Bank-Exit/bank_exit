class JSONHighlighter
  def initialize(json)
    @json = json
  end

  def colorize
    text = @json.is_a?(String) ? JSON.parse(@json) : @json

    colorize_value(text)
  end

  private

  def colorize_value(value, indent = 0)
    case value
    when Hash
      inner = value.map.with_index do |(k, v), i|
        key_html = "<span class='json-key'>\"#{ERB::Util.html_escape(k)}\"</span>"
        comma = i < value.size - 1 ? "<span class='json-punct'>,</span>" : ''
        "#{'  ' * (indent + 1)}#{key_html}<span class='json-punct'>: </span>#{colorize_value(v, indent + 1)}#{comma}\n"
      end.join
      "{\n#{inner}#{'  ' * indent}}"
    when Array
      inner = value.map.with_index do |v, i|
        comma = i < value.size - 1 ? "<span class='json-punct'>,</span>" : ''
        "#{'  ' * (indent + 1)}#{colorize_value(v, indent + 1)}#{comma}\n"
      end.join
      "[\n#{inner}#{'  ' * indent}]"
    when String
      colorize_primitive(value)
    when TrueClass, FalseClass
      "<span class='json-boolean'>#{value}</span>"
    when NilClass
      "<span class='json-null'>null</span>"
    when Numeric
      "<span class='json-number'>#{value}</span>"
    else
      "<span class='json-string'>#{ERB::Util.html_escape(value.to_s)}</span>"
    end
  end

  def colorize_primitive(str)
    clean = str.to_s

    if clean.match?(/\A-?\d+(\.\d+)?\z/)
      "<span class='json-number'>\"#{clean}\"</span>"
    elsif clean.match?(/^\d{4}-\d{2}-\d{2}$/) || clean.match?(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/i)
      "<span class='json-date'>\"#{ERB::Util.html_escape(clean)}\"</span>"
    elsif %w[true false yes no].include?(clean.downcase)
      "<span class='json-boolean'>\"#{clean}\"</span>"
    elsif clean == 'null'
      "<span class='json-null'>\"#{clean}\"</span>"
    else
      "<span class='json-string'>\"#{ERB::Util.html_escape(clean)}\"</span>"
    end
  end
end
