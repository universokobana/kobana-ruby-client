# frozen_string_literal: true

module Kobana
  class Client
    attr_reader :configuration

    def initialize(api_token: nil, environment: :sandbox, custom_headers: {}, debug: false, **extra_config)
      @configuration = Configuration.new
      @configuration.api_token = api_token
      @configuration.environment = environment
      @configuration.custom_headers = custom_headers
      @configuration.debug = debug

      # Allow any additional configuration options
      extra_config.each do |key, value|
        @configuration.public_send("#{key}=", value) if @configuration.respond_to?("#{key}=")
      end
    end

    def configure
      yield(@configuration) if block_given?
    end

    # Dynamically create resource accessors with metaprogramming
    %i[charge financial admin].each do |resource_type|
      define_method(resource_type) do
        instance_variable_get("@#{resource_type}") ||
          instance_variable_set("@#{resource_type}",
                                ResourceProxy.new(self, Resources.const_get(resource_type.to_s.capitalize)))
      end
    end

    # Generic proxy for all resource modules
    class ResourceProxy
      def initialize(client, module_ref)
        @client = client
        @module = module_ref
      end

      def method_missing(method_name, *args, &)
        # Convert method name to class name (e.g., :pix => Pix, :account_balance => AccountBalance)
        class_name = method_name.to_s.split("_").map(&:capitalize).join

        # Try to find the resource class
        if @module.const_defined?(class_name)
          resource_class = @module.const_get(class_name)
          # Return a client-bound version of the class
          resource_class.with_client(@client)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        class_name = method_name.to_s.split("_").map(&:capitalize).join
        @module.const_defined?(class_name) || super
      end
    end
  end
end
