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

        def create(data)
          response = request(:post, uri, data.to_json)
          case response[:status]
          when 201
            new(response[:data])
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
      end

      def update(data)
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
