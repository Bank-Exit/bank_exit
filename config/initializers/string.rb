class String
  # Converts a string into a deterministic, readable CSS hexadecimal color.
  #
  # The method generates a CRC32 hash from the string and extracts RGB values,
  # then adjusts contrast to ensure good readability (avoiding colors that are too dark or too light).
  #
  # @return [String] A CSS hex color string in the format "#RRGGBB"
  #
  # @example Basic usage
  #   "hello".to_rgb
  #   # => "#10A686"
  def to_rgb
    hash = Zlib.crc32(self)

    r = (hash >> 16) & 0xFF
    g = (hash >> 8) & 0xFF
    b = hash & 0xFF

    r, g, b = adjust_contrast(r, g, b)

    format('#%<r>02X%<g>02X%<b>02X', r: r, g: g, b: b)
  end

  private

  def adjust_contrast(r, g, b)
    # Compute perceived luminance (WCAG formula)
    luminance = (0.2126 * r) + (0.7152 * g) + (0.0722 * b)

    if luminance < 64
      # Too dark → lighten
      r = [r + 60, 255].min
      g = [g + 60, 255].min
      b = [b + 60, 255].min
    elsif luminance > 200
      # Too light → darken
      r = [r - 60, 0].max
      g = [g - 60, 0].max
      b = [b - 60, 0].max
    end

    [r, g, b]
  end
end
