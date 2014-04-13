module Infrataster
  module Types
    class BaseType
      # do nothing
      def name
        self.class.name.split('::').last[0...-4]
      end

      def context_class
        Contexts.const_get("#{name}Context")
      end
    end
  end
end

