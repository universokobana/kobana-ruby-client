# frozen_string_literal: true

unless defined?(ActiveSupport)
  class Hash
    unless method_defined?(:deep_symbolize_keys)
      def deep_symbolize_keys
        result = {}
        each do |key, value|
          sym_key = key.respond_to?(:to_sym) ? key.to_sym : key
          result[sym_key] = deep_symbolize_value(value)
        end
        result
      end

      private

      def deep_symbolize_value(value)
        case value
        when Hash
          value.deep_symbolize_keys
        when Array
          deep_symbolize_array(value)
        else
          value
        end
      end

      def deep_symbolize_array(array)
        array.map do |element|
          element.is_a?(Hash) ? element.deep_symbolize_keys : element
        end
      end
    end
  end
end
