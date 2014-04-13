module Infrataster
  module Contexts
    class BaseContext
      attr_reader :server
      attr_reader :type

      def initialize(server, type)
        @server = server
        @type = type
      end
    end
  end
end

