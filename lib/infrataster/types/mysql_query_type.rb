require 'infrataster/types/base_type'

module Infrataster
  module Types
    class MysqlQueryType < BaseType
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

