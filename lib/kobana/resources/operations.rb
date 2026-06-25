# frozen_string_literal: true

module Kobana
  module Resources
    module Operations
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def all(params = {})
          response = request(:get, uri(params), params)
          case response[:status]
          when 200
            response[:data].map { |data| new(data) }
          else
            handle_error_response(response)
            []
          end
        end

        def find_by(params = {}, options = {})
          result = all(params)
          return nil if result.empty? || (result.size > 1 && options[:ignore_multiple])

          match = params.all? do |key, value|
            result.first[key] == value
          end
          return unless match

          result.first
        end

        def create(attributes = {}, options = {})
          response = request(:post, uri(attributes), attributes, options)
          case response[:status]
          when 201
            new(response[:data].merge(created: true))
          else
            handle_error_response(response)
            resource = new(attributes.merge(created: false))
            resource.errors = @errors
            resource
          end
        end

        def find(resource_id, params = {})
          response = request(:get, "#{uri(params)}/#{resource_id}", params)
          case response[:status]
          when 200
            new(response[:data])
          else
            handle_error_response(response)
            nil
          end
        end

        def find_or_create_by(params, attributes = {}, options = {})
          options = { ignore_multiple: false, find_by_id: false, find_params: nil }.merge(options)
          if options[:find_by_id]
            find(params, options[:find_params]) || create(attributes)
          else
            find_by(params, options) || create(attributes.merge(params.deep_symbolize_keys), options)
          end
        end

        def handle_error_response(response)
          return unless response[:data].is_a?(Hash)

          @errors = response[:data][:errors] if response[:data].key?(:errors)
          @errors = [{ title: response[:data][:error] }] if response[:data].key?(:error)
        end
      end

      def save
        if new_record?
          response = self.class.create(attributes)
          if response.created?
            @attributes = response.attributes
            @errors = []
            true
          else
            @errors = response.errors
            false
          end
        else
          update({})
        end
      end

      def update(new_attributes = {})
        return if new_attributes.empty?

        data = attributes.merge(new_attributes.deep_symbolize_keys)
        response = request(:put, uri, data.to_json)
        case response[:status]
        when 200..204
          self.class.new(response[:data].merge(updated: true))
        else
          handle_error_response(response)
          resource = self.class.new(attributes.merge(updated: false))
          resource.errors = @errors
          resource
        end
      end

      # rubocop:disable Naming/PredicateMethod
      def delete
        response = request(:delete, uri)
        case response[:status]
        when 204
          true
        else
          handle_error_response(response)
          false
        end
      end
      # rubocop:enable Naming/PredicateMethod

      def list_commands(params = {})
        response = request(:get, "#{uri}/commands", params)
        case response[:status]
        when 200
          # response[:data].map { |command| Kobana::Resources::Command.new(command) }
          response[:data].map { |command| command }
        else
          handle_error_response(response)
          []
        end
      end

      def find_command(command_id)
        raise ArgumentError, "Command ID cannot be nil" if command_id.nil?

        response = request(:get, "#{uri}/commands/#{command_id}")
        case response[:status]
        when 200
          # response[:data].map { |command| Kobana::Resources::Command.new(command) }
          response[:data].map { |command| command }
        else
          handle_error_response(response)
          nil
        end
      end

      def handle_error_response(response)
        self.class.handle_error_response(response)
        @errors = self.class.errors
      end
    end
  end
end
