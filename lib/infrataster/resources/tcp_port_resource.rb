require 'infrataster/resources/base_resource'

module Infrataster
  module Resources
    class TcpPortResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :port

      def initialize(port, options = {})
        @port = port
      end

      def to_s
        "TCP port #{@port}"
      end
    end
  end
end

