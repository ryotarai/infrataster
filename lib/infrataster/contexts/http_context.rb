require 'faraday'

module Infrataster
  module Contexts
    class HttpContext < BaseContext
      def response
        server.gateway_on_from_server(resource.uri.port) do |address, port|
          url = "#{resource.uri.scheme}://#{address}:#{port}"

          conn = Faraday.new(:url => url) do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger, Logger
            faraday.adapter  Faraday.default_adapter
          end

          conn.public_send(resource.method) do |req|
            resource.params.each_pair do |k, v|
              req.params[k] = v
            end
            req.headers['Host'] = resource.uri.host
            resource.headers.each_pair do |k, v|
              req.headers[k] = v
            end
            req.url resource.uri.path
          end
        end
      end
    end
  end
end


