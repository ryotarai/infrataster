require 'infrataster/types'
require 'infrataster/contexts/base_context'
require 'infrataster/contexts/http_context'
require 'infrataster/contexts/mysql_query_context'
require 'infrataster/contexts/capybara_context'

module Infrataster
  module Contexts
    class << self
      def from_example(example)
        example_group = example.metadata[:example_group]

        server = find_described(Types::ServerType, example_group).server
        type = find_described(Types::BaseType, example_group)

        type.context_class.new(server, type)
      end

      private
      def find_described(type_class, example_group)
        arg = example_group[:description_args].first
        if arg.is_a?(type_class)
          arg
        else
          parent_example_group = example_group[:example_group]
          if parent_example_group
            find_described(type_class, parent_example_group)
          else
            raise Error
          end
        end
      end
    end
  end
end

