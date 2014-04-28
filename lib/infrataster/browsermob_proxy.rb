require 'browsermob/proxy'

module Infrataster
  module BrowsermobProxy
    class << self
      def server
        @server ||= start_server
      end

      def proxy
        @proxy ||= server.create_proxy
      end

      def bin_path
        @bin_path
      end

      def bin_path=(path)
        @bin_path = path
      end

      private
      def start_server
        BrowserMob::Proxy::Server.new(find_bin).tap do |server|
          server.start
        end
      end

      def find_bin
        return @bin_path if @bin_path
        `which browsermob-proxy`
      end
    end
  end
end

