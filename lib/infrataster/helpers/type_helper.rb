require 'infrataster/types'

module Infrataster
  module Helpers
    module TypeHelper
      def server(*args)
        Types::ServerType.new(*args)
      end

      def http(*args)
        Types::HttpType.new(*args)
      end

      def mysql_query(*args)
        Types::MysqlQueryType.new(*args)
      end

      def capybara(*args)
        Types::CapybaraType.new(*args)
      end
    end
  end
end

