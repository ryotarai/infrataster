require 'infrataster/resources'
require 'infrataster/contexts/base_context'
require 'infrataster/contexts/no_resource_context'
require 'infrataster/contexts/http_context'
require 'infrataster/contexts/capybara_context'

module Infrataster
  module Contexts
    class << self
      def from_example(example)
        eg = example_group(example)

        server_resource = find_described(Resources::ServerResource, eg)
        resource = find_described(Resources::BaseResource, eg)

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

      def example_group(example)
        if RSpec::Core::Version::STRING.start_with?('2')
          example.metadata[:example_group]
        else
          example.example_group
        end
      end

      def find_described(resource_class, example_group)
        arg = example_group_arg(example_group)
        if arg.is_a?(resource_class)
          arg
        else
          parent_eg = parent_example_group(example_group)
          find_described(resource_class, parent_eg) if parent_eg
        end
      end

      def parent_example_group(example_group)
        if RSpec::Core::Version::STRING.start_with?('2')
          example_group[:example_group]
        else
          example_group.parent_groups[1]
        end
      end

      def example_group_arg(example_group)
        if RSpec::Core::Version::STRING.start_with?('2')
          example_group[:description_args].first
        else
          example_group.metadata[:description_args].first
        end
      end
    end
  end
end
