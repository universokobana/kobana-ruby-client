# frozen_string_literal: true

module Kobana
  module Resources
    module Operations
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def all(params = {})
          response = request(:get, uri, params)
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
          return nil if result.size > 1 && options[:ignore_multiple]

          match = params.all? do |key, value|
            result.first[key] == value
          end
          return unless match

          result.first
        end

        def create(attributes = {})
          response = request(:post, uri, attributes.to_json)
          case response[:status]
          when 201
            new(response[:data].merge(created: true))
          else
            handle_error_response(response)
            new(attributes.merge(errors: errors, created: false))
          end
        end

        def find(resource_id, params = {})
          response = request(:get, "#{uri}/#{resource_id}", params)
          case response[:status]
          when 200
            new(response[:data])
          else
            handle_error_response(response)
            nil
          end
        end

        def find_or_create_by(find_by_params, attributes = {})
          find_by(find_by_params, ignore_multiple: true) || create(attributes.merge(find_by_params.deep_symbolize_keys))
        end

        def handle_error_response(response)
          return unless response[:data].is_a?(Hash)

          self.errors = response[:data][:errors] if response[:data].key?(:errors)
          self.errors = [title: response[:data][:error]] if response[:data].key?(:error)
        end
      end

      def update(new_attributes = {})
        return if new_attributes.empty?

        data = attributes.merge(new_attributes.deep_symbolize_keys)
        response = request(:put, uri, data.to_json)
        case response[:status]
        when 200..204
          new(response[:data].merge(updated: true))
        else
          handle_error_response(response)
          new(attributes.merge(errors: errors, updated: false))
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
        self.errors = self.class.errors
      end
    end
  end
end
