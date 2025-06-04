# frozen_string_literal: true

module Kobana
  module Resources
    module Financial
      class Account < Base
        self.resource_endpoint = "financial/accounts"
      end
    end
  end
end
