# frozen_string_literal: true

module KobanaRubyClient
  module Resources
    module BankBillet
      class BankBillet < KobanaRubyClient::Base
        def index
          url = "#{base_url}/bank_billets"
          response = connection.get(url)
          parse_response(response)
        end

        def create(data)
          url = "#{base_url}/bank_billets"
          response = connection.post(url, data.to_json)
          parse_response(response)
        end
      end
    end
  end
end
