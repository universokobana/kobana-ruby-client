# frozen_string_literal: true

class Hash
  def deep_symbolize_keys
    result = {}
    each do |key, value|
      sym_key = key.respond_to?(:to_sym) ? key.to_sym : key
      result[sym_key] =
        case value
        when Hash
          value.deep_symbolize_keys
        when Array
          value.map { |v| v.is_a?(Hash) ? v.deep_symbolize_keys : v }
        else
          value
        end
    end
    result
  end
  # rubocop:enable Metrics/MethodLength
end
