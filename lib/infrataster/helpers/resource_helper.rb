require 'infrataster/resources'

module Infrataster
  module Helpers
    module ResourceHelper
      include RSpec::Matchers


      def method_missing(method, *args)
        resource_class_name = method.to_s.split('_').map {|word| word.capitalize }.join
        resource_class_name << 'Resource'
        begin
          Resources.const_get(resource_class_name).new(*args)
        rescue
          super(method, *args)
        end
      end
    end
  end
end

