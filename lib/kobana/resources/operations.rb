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

        def create(data)
          response = request(:post, uri, data.to_json)
          case response[:status]
          when 201
            new(response[:data].merge(created: true))
          else
            false
          end
        end

        def find(resource_id, params = {})
          response = request(:get, "#{uri}/#{resource_id}", params)
          case response[:status]
          when 200
            new(response[:data])
          end
        end

        def find_or_create_by(find_by_params, attributes = {})
          find_by(find_by_params, ignore_multiple: true) || create(attributes.merge(find_by_params.deep_symbolize_keys))
        end
      end

      def update(new_attributes = {})
        return if new_attributes.empty?

        data = attributes.merge(new_attributes.deep_symbolize_keys)
        request(:put, uri, data.to_json)
      end

      def delete
        request(:delete, uri)
      end

      def list_commands(params = {})
        response = request(:get, "#{uri}/commands", params)
        case response[:status]
        when 200
          # response[:data].map { |command| Kobana::Resources::Command.new(command) }
          response[:data].map { |command| command }
        end
      end

      def find_command(command_id)
        raise ArgumentError, "Command ID cannot be nil" if command_id.nil?

        response = request(:get, "#{uri}/commands/#{command_id}")
        case response[:status]
        when 200
          # response[:data].map { |command| Kobana::Resources::Command.new(command) }
          response[:data].map { |command| command }
        end
      end
    end
  end
end
