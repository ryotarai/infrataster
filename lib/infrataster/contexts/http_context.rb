require 'faraday'
require 'faraday_middleware'

module Infrataster
  module Contexts
    class HttpContext < BaseContext
      def response
        server.forward_port(resource.uri.port) do |address, port|
          url = "#{resource.uri.scheme}://#{address}:#{port}"
          options = {:url => url}

          if resource.uri.scheme == 'https'
            options[:ssl] = resource.ssl_option
          end

          host = determine_host(address)

          conn = Faraday.new(options) do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger, Logger
            middlewares(host => address).each do |middleware|
              faraday.use(*middleware)
            end
            faraday.adapter  Faraday.default_adapter
            faraday.basic_auth(*resource.basic_auth) if resource.basic_auth
          end

          conn.public_send(resource.method) do |req|
            resource.params.each_pair do |k, v|
              req.params[k] = v
            end
            req.headers['Host'] = host
            resource.headers.each_pair do |k, v|
              req.headers[k] = v
            end

            req.body = resource.body if resource.body

            req.url resource.uri.path
          end
        end
      end

      def determine_host(default)
        resource.uri.host || (server.options[:http] && server.options[:http][:host]) || default
      end

      private

      def middlewares(host_mapping)
        host_mapping = resource.host_mapping.merge(host_mapping)

        ms = resource.faraday_middlewares.dup
        if resource.follow_redirects?
          ms << [Infrataster::FaradayMiddlewares::FollowRedirects, host_mapping: host_mapping]
        end
        if resource.inflate_gzip?
          ms << [FaradayMiddleware::Gzip]
        end

        ms
      end
    end
  end
end
