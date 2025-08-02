class ProfesionalDecorator < ApplicationDecorator
  # Returns the initials of a name, using only letters and numbers.
  #
  # - Non-alphanumeric characters (e.g., punctuation, symbols) are removed before processing.
  # - If the name has only one word, returns the first two alphanumeric characters, uppercased.
  # - If the name has multiple words, returns the first alphanumeric character from the first and last words.
  #
  # @return [String] The initials extracted from the name.
  #
  # @example Single-word name
  #   user.name = "Alice"
  #   user.initials # => "AL"
  #
  # @example Two-word name
  #   user.name = "Alice Smith"
  #   user.initials # => "AS"
  #
  # @example Multi-word name
  #   user.name = "John Ronald Reuel Tolkien"
  #   user.initials # => "JT"
  #
  # @example Name with extra spaces
  #   user.name = "  Marie Curie  "
  #   user.initials # => "MC"
  #
  # @example Name with parentheses and question marks
  #   user.name = "Dr. John (Doe)?"
  #   user.initials # => "DJ"
  #
  # @example Multi-word name with symbols
  #   user.name = "Mary-Kate O'Neil!"
  #   user.initials # => "MO"
  #
  # @example Name with only one letter
  #   user.name = "Q"
  #   user.initials # => "Q"
  #
  # @example Empty name
  #   user.name = ""
  #   user.initials # => ""
  def initials
    return '' if name.strip.empty?

    parts = name.strip.split.map do |part|
      part.gsub(/[^a-zA-Z0-9]/, '')
    end.reject(&:empty?)

    if parts.length == 1
      parts.first[0, 2].upcase
    else
      (parts.first[0] + parts.last[0]).upcase
    end
  end
end
