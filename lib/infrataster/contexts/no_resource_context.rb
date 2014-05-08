module Infrataster
  module Contexts
    class NoResourceContext < BaseContext
      def initialize(server)
        super(server, nil)
      end
    end
  end
end


