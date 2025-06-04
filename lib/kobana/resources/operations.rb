# frozen_string_literal: true

module Kobana
  module Resources
    module Operations
      def index(params = {})
        url = "#{base_url}/#{endpoint}"
        response = connection.get(url, params)
        parse_response(response)
      end

      def create(data)
        url = "#{base_url}/#{endpoint}"
        response = connection.post(url, data.to_json)
        parse_response(response)
      end

      def find(resource_id)
        url = "#{base_url}/#{endpoint}/#{resource_id}"
        response = connection.get(url)
        parse_response(response)
      end

      def list_command(resource_id, params = {})
        url = "#{base_url}/#{endpoint}/#{resource_id}/commands"
        response = connection.get(url, params)
        parse_response(response)
      end

      def find_command(resource_id, command_id)
        url = "#{base_url}/#{endpoint}/#{resource_id}/commands/#{command_id}"
        response = connection.get(url)
        parse_response(response)
      end

      private

      def endpoint
        self.class.resource_endpoint
      end
    end
  end
end
