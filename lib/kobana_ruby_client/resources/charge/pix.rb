# frozen_string_literal: true

module KobanaRubyClient
  module Resources
    module Charge
      class Pix < KobanaRubyClient::Base
        def index
          url = "#{base_url}/charge/pix"
          response = connection.get(url)
          parse_response(response)
        end

        def create(data)
          url = "#{base_url}/charge/pix"
          response = connection.post(url, data.to_json)
          parse_response(response)
        end

        def find(charge_id)
          url = "#{base_url}/charge/pix/#{charge_id}"
          response = connection.get(url)
          parse_response(response)
        end
      end
    end
  end
end
