# frozen_string_literal: true

require "faraday"
require "json"

module Kobana
  module Resources
    class Base
      include Connection
      include Operations

      class << self
        attr_accessor :primary_key, :api_version, :resource_endpoint

        def inherited(subclass)
          super
          subclass.resource_endpoint ||= infer_resource_endpoint(subclass)
          subclass.primary_key ||= :uid
          subclass.api_version ||= :v2
        end

        def infer_resource_endpoint(klass)
          return resource_endpoint if resource_endpoint

          return unless klass.name =~ /Kobana::Resources::(.*)$/

          ::Regexp.last_match(1).underscore.pluralize
        end

        def uri
          "#{base_url}/#{resource_endpoint}"
        end
      end

      attr_accessor :attributes

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
        "#{self.class.uri}/#{attributes[self.class.primary_key]}"
      end

      def request(*)
        self.class.request(*)
      end
    end
  end
end
