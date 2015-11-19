require 'infrataster/resources/base_resource'
require 'uri'

module Infrataster
  module Resources
    class HttpResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :uri, :options

      def initialize(url_str, options = {})
        @options = {params: {}, method: :get, headers: {}}.merge(options)
        @uri = URI.parse(url_str)
        if @uri.scheme
          unless %w!http https!.include?(@uri.scheme)
            raise Error, "The provided url, '#{@uri}', is not http or https."
          end
        else
          @uri = URI::HTTP.build([@uri.userinfo, @uri.host, @uri.port, @uri.path, @uri.query, @uri.fragment])
        end
      end

      def to_s
        "http '#{@uri}' with #{@options}"
      end

      def params
        @options[:params]
      end

      def method
        valid_methods = [:get, :head, :delete, :post, :put, :patch]
        unless valid_methods.include?(@options[:method])
          raise Error, "#{@options[:method]} is not supported HTTP method."
        end

        @options[:method]
      end

      def headers
        @options[:headers]
      end

      def body
        @options[:body]
      end

      def ssl_option
        @options[:ssl]
      end

      def basic_auth
        @options[:basic_auth]
      end

      def inflate_gzip?
        !!@options[:inflate_gzip]
      end

      def follow_redirects?
        !!@options[:follow_redirects]
      end

      def faraday_middlewares
        (@options[:faraday_middlewares] || []).map do |m|
          Array(m)
        end
      end

      def host_mapping
        @options[:host_mapping] || {}
      end
    end
  end
end
