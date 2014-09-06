module Infrataster
  module Helpers
    module RSpecHelper
      def method_missing(method, *args)
        if current_infrataster_context.respond_to?(method)
          return current_infrataster_context.public_send(method, *args)
        end

        super
      end

      def current_infrataster_context
        @infrataster_context
      end
    end
  end
end


