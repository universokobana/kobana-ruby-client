# frozen_string_literal: true

module Kobana
  module Resources
    module Charge
      class Pix < Base
        include ResourceOperations

        @resource_endpoint = "charge/pix"

        class << self
          attr_reader :resource_endpoint
        end
      end
    end
  end
end
