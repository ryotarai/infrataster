require 'infrataster/resources/base_resource'

module Infrataster
  module Resources
    class MysqlQueryResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :query

      def initialize(query, options = {})
        @query = query
        @options = options
      end

      def to_s
        "mysql '#{@query}'"
      end
    end
  end
end

