require 'infrataster/resources'

module Infrataster
  module Helpers
    module ResourceHelper
      include RSpec::Matchers

      def server(*args)
        Resources::ServerResource.new(*args)
      end

      def http(*args)
        Resources::HttpResource.new(*args)
      end

      def mysql_query(*args)
        Resources::MysqlQueryResource.new(*args)
      end

      def capybara(*args)
        Resources::CapybaraResource.new(*args)
      end
    end
  end
end

