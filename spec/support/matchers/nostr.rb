RSpec::Matchers.define :match_nostr_tags do |expected|
  match do |actual|
    grouped = actual.group_by(&:first).transform_values { |v| v.map(&:last) }

    expected.all? do |raw_key, expected_value|
      key = raw_key.to_s

      unless grouped.key?(key)
        @failure_message = "expected key #{key.inspect} to exist"
        next false
      end

      actual_values = grouped[key]

      if expected_value.is_a?(Array)
        matcher = RSpec::Matchers::BuiltIn::ContainExactly.new(expected_value)

        unless matcher.matches?(actual_values)
          @failure_message =
            "expected #{key} values #{actual_values.inspect} to equal #{expected_value.inspect}"
          next false
        end
      else
        matcher = RSpec::Matchers::BuiltIn::Match.new(expected_value)

        unless matcher.matches?(actual_values.first)
          @failure_message =
            "expected #{key} value #{actual_values.first.inspect} to match #{expected_value.inspect}"
          next false
        end
      end

      true
    end
  end

  failure_message do
    @failure_message || 'expected tags to match'
  end
end
