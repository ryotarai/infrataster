module Infrataster
  module Resources
    class BaseResource
      # do nothing
      def name
        self.class.name.split('::').last[0...(-1 * 'Resource'.size)]
      end

      def context_class
        Contexts.const_get("#{name}Context")
      end
    end
  end
end

