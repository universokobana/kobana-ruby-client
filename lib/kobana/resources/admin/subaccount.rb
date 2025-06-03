# frozen_string_literal: true

module Kobana
  module Resources
    module Admin
      class Subaccount < Base
        include ResourceOperations

        @resource_endpoint = "admin/subaccounts"

        class << self
          attr_reader :resource_endpoint
        end
      end
    end
  end
end
