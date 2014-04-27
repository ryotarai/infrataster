require 'faraday'

module Infrataster
  module Contexts
    class HttpContext < BaseContext
      def response
        server.from_gateway(resource.uri.port) do |address, port|
          url = "#{resource.uri.scheme}://#{address}:#{port}"

          conn = Faraday.new(:url => url) do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger, Logger
            faraday.adapter  Faraday.default_adapter
          end

          conn.get do |req|
            req.headers['Host'] = resource.uri.host
            req.url resource.uri.path
          end
        end
      end
    end
  end
end


