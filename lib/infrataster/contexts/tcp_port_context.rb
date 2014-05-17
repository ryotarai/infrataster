require 'socket'
require 'net/ping/tcp'

module Infrataster
  module Contexts
    class TcpPortContext < BaseContext
      def opened?
        server.forward_port(resource.port) do |host, port|
          begin
            TCPSocket.new(host, port)
          rescue Errno::ECONNREFUSED
            false
          else
            true
          end
        end
      end
    end
  end
end


