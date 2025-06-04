# frozen_string_literal: true

require "faraday"
require "json"

module Kobana
  module Resources
    class Base
      include Connection
      include Operations
      attr_accessor :attributes

      class << self
        attr_accessor :primary_key, :resource_endpoint

        def uri
          "#{base_url}/#{resource_endpoint}"
        end
      end

      def initialize(attributes = {})
        @attributes = attributes.deep_symbolize_keys
      end

      def [](key)
        attributes[key.to_sym]
      end

      def method_missing(key, *, &)
        return unless attributes.key?(key.to_sym)

        attributes[key]
      end

      def respond_to_missing?(key, include_private = false)
        attributes.key?(key.to_sym) || super
      end

      def uri
        "#{self.class.uri}/#{attributes[self.class.primary_key || :id]}"
      end

      def request(*)
        self.class.request(*)
      end
    end
  end
end
