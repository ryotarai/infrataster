require 'net/http'
require 'net/https'

module Infrataster
  module Contexts
    class HttpContext < BaseContext
      def response
        req = Net::HTTP::Get.new('/', {'Host' => type.uri.host})

        server.from_gateway(type.uri.port) do |address, port|
          Net::HTTP.start(address, port) do |http|
            http.request(req)
          end
        end
      end
    end
  end
end


