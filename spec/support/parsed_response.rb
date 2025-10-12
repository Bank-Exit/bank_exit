module ParsedResponse
  def parsed_response
    with_indifferent_keys(JSON.parse(response.body))
  end

  # Return list of ids for a collection resources
  #
  # @return [Array<Integer>]
  def parsed_response_ids
    parsed_response.pluck(:id)
  end

  private

  def with_indifferent_keys(object)
    case object
    when Hash
      object.with_indifferent_access.transform_values { |value| with_indifferent_keys(value) }
    when Array
      object.map { |e| with_indifferent_keys(e) }
    else object
    end
  end
end

RSpec.configure do |config|
  config.include ParsedResponse
end
