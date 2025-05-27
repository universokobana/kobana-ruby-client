# frozen_string_literal: true

module Kobana
  module Resources
    module Financial
      class Account < Base
        include ResourceOperations

        @resource_endpoint = "financial/accounts"

        class << self
          attr_reader :resource_endpoint
        end
      end 
    end
  end
end
