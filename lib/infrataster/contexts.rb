require 'infrataster/resources'
require 'infrataster/contexts/base_context'
require 'infrataster/contexts/no_resource_context'
require 'infrataster/contexts/http_context'
require 'infrataster/contexts/capybara_context'

module Infrataster
  module Contexts
    class << self
      def from_example(example)
        example_group = example.metadata[:example_group]

        server_resource = find_described(Resources::ServerResource, example_group)
        resource = find_described(Resources::BaseResource, example_group)

        unless server_resource || resource
          # There is neither server_resource or resource
          return nil
        end

        if server_resource && !resource
          # Server is found but resource is not found
          return Contexts::NoResourceContext.new(server_resource.server)
        end

        resource.context_class.new(server_resource.server, resource)
      end

      private
      def find_described(resource_class, example_group)
        arg = example_group[:description_args].first
        if arg.is_a?(resource_class)
          arg
        else
          parent_example_group = example_group[:example_group]
          if parent_example_group
            find_described(resource_class, parent_example_group)
          end
        end
      end
    end
  end
end

