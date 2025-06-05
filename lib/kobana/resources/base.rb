# frozen_string_literal: true

require "faraday"
require "json"

module Kobana
  module Resources
    class Base
      include Connection
      include Operations

      class << self
        attr_accessor :primary_key, :api_version, :resource_endpoint, :errors, :default_attributes

        def inherited(subclass)
          super
          subclass.resource_endpoint ||= infer_resource_endpoint(subclass)
          subclass.primary_key ||= :uid
          subclass.api_version ||= :v2
          subclass.errors ||= []
          subclass.default_attributes ||= {}
        end

        def infer_resource_endpoint(klass)
          return resource_endpoint if resource_endpoint

          return unless klass.name =~ /Kobana::Resources::(.*)$/

          ::Regexp.last_match(1).underscore.pluralize
        end

        def uri(attributes = {})
          "#{base_url}/#{interpolate(resource_endpoint, default_attributes.merge(attributes))}"
        end

        def interpolate(template, attributes)
          template.gsub(/\{([^\}]+)\}/) do
            key = Regexp.last_match(1)
            begin
              attributes[key.to_sym].to_s
            rescue NameError
              "{#{key}}" # Keep original if variable is undefined
            end
          end
        end
      end

      attr_accessor :attributes, :errors

      def initialize(attributes = {})
        @attributes = attributes.deep_symbolize_keys
        @errors = []
      end

      def [](key)
        attributes[key.to_sym]
      end

      def method_missing(key, *args, &)
        if key.to_s.end_with?("=")
          key = key.to_s.chomp("=").to_sym
          attributes[key] = args.first
        else
          return unless attributes.key?(key.to_sym)

          attributes[key]
        end
      end

      def respond_to_missing?(key, include_private = false)
        attributes.key?(key.to_sym) || super
      end

      def uri
        "#{self.class.uri(attributes)}/#{attributes[self.class.primary_key]}"
      end

      def request(*)
        self.class.request(*)
      end

      def valid?
        errors.empty?
      end

      def created?
        attributes[:created] || false
      end

      def updated?
        attributes[:updated] || false
      end

      def new_record?
        primary_key.nil? || primary_key.to_s.empty?
      end

      def primary_key
        attributes[self.class.primary_key]
      end
    end
  end
end
