module Infrataster
  module Helpers
    module RSpecHelper
      def method_missing(method, *args)
        current_infrataster_context.public_send(method, *args)
      end

      def current_infrataster_context
        @infrataster_context
      end
    end
  end
end


