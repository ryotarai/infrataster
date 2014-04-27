module Infrataster
  module Resources
    class ServerResource
      Error = Class.new(StandardError)

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def to_s
        desc = "server '#{server.name}'"
        desc += " from '#{server.from.name}'" if server.from
        desc
      end

      def server
        Server.find_by_name(@name)
      end
    end
  end
end


