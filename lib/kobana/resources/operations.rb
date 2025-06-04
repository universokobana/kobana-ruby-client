# frozen_string_literal: true

module Kobana
  module Resources
    module Operations
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def all(params = {})
          url = "#{base_url}/#{resource_endpoint}"
          response = connection.get(url, params)
          parse_response(response)
        end

        def create(data)
          url = "#{base_url}/#{resource_endpoint}"
          response = connection.post(url, data.to_json)
          parse_response(response)
        end

        def find(resource_id, params = {})
          url = "#{base_url}/#{resource_endpoint}/#{resource_id}"
          response = connection.get(url, params)
          parse_response(response)
        end
      end

      def update(resource_id, data)
        url = "#{base_url}/#{resource_endpoint}/#{resource_id}"
        response = connection.put(url, data.to_json)
        parse_response(response)
      end

      def delete(resource_id)
        url = "#{base_url}/#{resource_endpoint}/#{resource_id}"
        response = connection.delete(url)
        parse_response(response)
      end

      def list_command(resource_id, params = {})
        url = "#{base_url}/#{resource_endpoint}/#{resource_id}/commands"
        response = connection.get(url, params)
        parse_response(response)
      end

      def find_command(resource_id, command_id)
        raise ArgumentError, "Command ID and Resource ID cannot be nil" if command_id.nil? || resource_id.nil?

        url = "#{base_url}/#{resource_endpoint}/#{resource_id}/commands/#{command_id}"
        response = connection.get(url)
        parse_response(response)
      end
    end
  end
end
